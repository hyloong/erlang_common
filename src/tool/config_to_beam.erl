%% ------------------------------------------------------------------
%% @author zhongwencool@gmail.com
%% @doc   把对应的.config文件转为.beam文件并更新到内存
%%        configName:all()       return all key_value
%%        configName:lookup(Key) return value or undefined
%% 1.得到目录下文件集合
%% 2.遍历对每个文件进行转换
%%   2.1 把文件读入 检查格式
%%   2.2 把config转化为erl文件
%%   2.2 把erl文件编译成beam文件
%% 3.加载beam文件到内存
%% @end
%% Created : 22. Aug 2014 4:08 PM
%% ------------------------------------------------------------------
-module(config_to_beam).

-compile(export_all).
%% API
-export([config_to_beam/0,config_to_beam/1,get_config_dir/0]).

%% @doc 把指定目录下全部的config文件都转为.beam文件并加载到内存
config_to_beam() ->
    AllConfigName = get_all_config_name(),
    [begin
         config_to_beam(ConfigName)
     end||ConfigName <- AllConfigName].

%% @doc 把指定目录下名为ConfigName的config文件转为.beam文件并加载到内存
config_to_beam(ConfigName) ->
    case check_syntax(ConfigName) of
        {ok, TermList}  ->
            term_to_beam(ConfigName -- ".config", TermList);
        Reason ->
            io:format("check Config syntax error~p:Reason:~p~n",[ConfigName, Reason]),
            {Reason,ConfigName}
    end.

%% @todo 改成你存放.config文件的目录
get_config_dir() ->
    code:root_dir()++"/config".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Internal Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
term_to_beam(ModuleName,TermList) ->
    Erl = term_to_erl(ModuleName,TermList),
    ModuleName2 = ModuleName++".erl",
    file:write_file(ModuleName2, Erl, [write, binary, {encoding, utf8}]),
    compile:file(ModuleName2),
    ModuleName3 = list_to_atom(ModuleName),
    code:purge(ModuleName3),
    code:load_file(ModuleName3),
    {ok,ModuleName3}.

term_to_erl(ModuleName,TermList) ->
    StrValue = lists:flatten(term_to_erl2(TermList,"")),
    StrList = lists:flatten(io_lib:format("     ~w\n", [TermList])),
    "
    -module(" ++ ModuleName ++ ").
-export([all/0,lookup/1]).

all()->"++ StrList ++".

lookup(Key) ->
    case Key of
        " ++ StrValue ++ "
        _ -> undefined
    end.
".

term_to_erl2([],Sum) ->
    Sum;
term_to_erl2([{Key, Value}|Left],Acc) ->
    term_to_erl2(Left,
                 io_lib:format("       ~w -> ~w;\n",[Key, Value])++Acc).

get_all_config_name() ->
    {ok,AllFileName} = file:list_dir(get_config_dir()),
    lists:filter(fun(FileName) ->
                         case lists:reverse(FileName) of
                             "gifnoc." ++_ -> true;
                             _ -> false
                         end
                 end,AllFileName).

check_syntax(ConfigName) ->
    case file:consult(joint_path(ConfigName)) of
        {ok, TermList = [_|_]} ->
            check_fromat_duplicate(TermList, []);
        Reason ->
            {error, Reason}
    end.

joint_path(ConfigName) ->
    get_config_dir() ++"/" ++ ConfigName.

check_fromat_duplicate([], Acc) ->
    {ok, Acc};
check_fromat_duplicate([{Key, _Value} = Term|Left], Acc) ->
    case lists:keymember(Key, 1, Acc) of
        true -> {error, key_duplicate, Key};
        false -> check_fromat_duplicate(Left, [Term|Acc])
    end;
check_fromat_duplicate([Term|_],_Acc) ->
    {error,format_error,Term}.
