%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  8 Apr 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(gs_test_node).

-behaviour(gen_server).

%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
start_link(1, N) ->
    R = gen_server:start_link({local, ?MODULE}, ?MODULE, [], []),
    test_smsg1(1, N),
    R;
start_link(2, N) ->
    R = gen_server2:start_link({local, ?MODULE}, ?MODULE, [], []),
    test_smsg1(2, N),
    R.

test_smsg1(Type, N) when is_integer(N)->
    Name = case node() of 
               'c1@127.0.0.1' -> 'c0@127.0.0.1';
               _ -> 'c1@127.0.0.1'
           end,
    if 
        N == 0 -> skip;
        true ->
            String = "我不是假的，我是真的来测试数据的怎么样？是不是据的很惊讶，但是你不必惊讶，因为那是琼鱼告诉我一定要作的，大鱼海棠，这是石么，好看，我感觉还好，周末约看电影吗？还是算了，决定在家里学习包子！是不是很逗，应该是。天都快给你聊死了！！！好了，就这样吧，五一还是回家好，我已经许久没有回家了。",
            spawn_link(fun() -> test_smsg(Type, Name, String) end),
            test_smsg1(Type, N-1)
    end.

test_smsg(1, Name, String)->
    rpc:cast(Name, common_test_node, test_smsg_format, [1, Name, String]);
    %% gen_server:cast(?MODULE, {test_smsg, 1, Name, String});

test_smsg(2, Name, String)->
    rpc:cast(Name, common_test_node, test_smsg_format, [2, Name, String]).
    %% gen_server2:cast(?MODULE, {test_smsg, 2, Name, String}).

test_smsg_format(1, Name, String)->
    gen_server:cast(?MODULE, {test_smsg_format, 1, Name, String});

test_smsg_format(2, Name, String)->
    gen_server2:cast(?MODULE, {test_smsg_format, 2, Name, String}).

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
init([]) ->
    {ok, []}.

%%--------------------------------------------------------------------
handle_call(_Request, From, State) ->
    case catch do_handle_call(_Request, From, State) of
        {'EXIT', _Reason} ->
            io:format("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            util:errlog("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            Reply = ok,
            {reply, Reply, State};
        {reply, Reply, NewState} ->
            {reply, Reply, NewState}
                end.

%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    case catch do_handle_cast(_Msg, State) of
        {'EXIT', _Reason} ->
            io:format("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            util:errlog("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState}
                end.

%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    case catch do_handle_info(_Info, State) of
        {'EXIT', _Reason} ->
            io:format("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            util:errlog("~p ~p Error Reason:~p~n", [?MODULE, ?LINE, _Reason]),
            {noreply, State};
        {noreply, NewState} ->
            {noreply, NewState}
                end.

%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
do_handle_call(_Request, _From, State)->
    {reply, ok, State}.

do_handle_cast({test_smsg, Type, Name, String}, State)->
    %% rpc:cast(Name, common_test_node, test_smsg_format, [Type, node(), String]),
    {noreply, State};

do_handle_cast({test_smsg_format, Type, Name, String}, State)->
    {noreply, State};

do_handle_cast(_Msg, State)->
    {noreply, State}.

do_handle_info(_Info, State)->
    {noreply, State}.
