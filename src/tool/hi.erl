%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%  
%%% @end 
%%% Created : 17 Mar 2017 by root <root@localhost.heller>

-module(hi).

-export([do/0, do/1]).

do()->
    %% preloaded 预加载
    [turn(M, P)|| {M, P} <- code:all_loaded(), P=/=preloaded].

do(Mod) ->
    [turn(M, P) || {M, P} <- code:all_loaded(), M == Mod].
    

turn(M, P) ->
    %% 目录路径去掉文件名P = path
    Path = filename:dirname(P),
    MName = filename:basename(P, ".beam"),
    MPath = binary_to_list(iolist_to_binary(re:replace(filename:join(Path, MName), "ebin", "src"))),
    %% 模块信息
    L = M:module_info(),
    COpts = get_compile_options(L),
    %% 新的编译参数
    NewCOpts = lists:foldr(
               fun({K, V}, Acc) when is_list(V) and is_integer(hd(V)) ->
                       if
                           K == outdir ->
                               [{K, Path}] ++ Acc;
                           true ->
                               [{K, tr(V)}] ++ Acc 
                       end;
                  (Skip, Acc) ->
                       Acc ++ [Skip]
               end,
               [], COpts),

    case lists:member(native, NewCOpts) of 
        false -> %% 编译选项：time, eprof可以统计编译时间
            c:c(MPath, NewCOpts ++ [native, "{hipe, [o3]}"]);
        true ->
            c:c(MPath, NewCOpts -- [native, "{hipe, [o3]}"])
    end.

%% Compiled: No compile time info available
%% Object file: /usr/local/lib/erlang/lib/stdlib-3.4/ebin/lists.beam
%% Compiler options:  [debug_info,
%%                     {i,"/net/isildur/ldisk/daily_build/20_prebuild_master-opu_o.2017-06-20_20/otp_src_20/lib/stdlib/src/../include"},
%%                     {i,"/net/isildur/ldisk/daily_build/20_prebuild_master-opu_o.2017-06-20_20/otp_src_20/lib/stdlib/src/../../kernel/include"}]
tr(P)->
    Str = "/net/isildur/ldisk/daily_build/20_prebuild_master-opu_o.2017-06-20_20",
    ReStr = "/root/heller",
    %% m(lists),实际情况修改
    binary_to_list(iolist_to_binary(re:replace(P, Str, ReStr))).

get_compile_options(L) ->
    case get_compile_info(L, options) of
        {ok,Val} -> Val;
        error -> []
    end.

get_compile_info(L, Tag) ->
    case lists:keysearch(compile, 1, L) of
        {value, {compile, I}} ->
            case lists:keysearch(Tag, 1, I) of
                {value, {Tag, Val}} -> {ok,Val};
                false -> error
            end;
        false -> error
    end.
