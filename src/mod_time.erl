%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%% 避免多个进程读取时间，防止时间过多的修正，锁的操作
%%% @end
%%% Created :  2 May 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(mod_time).

-behaviour(gen_server).

%% API
-export([start_link/0, now/0]).

-export([get_time1/0, get_time2/0, get_time3/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(Time, 1000).

-record(state, {
          now_time = 0,      %% 时间
          now_seconds = 0,   %% 现在的秒
          time_ref = []      %% 每秒定时器
         }).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

now()->
    gen_server:call(misc:get_global_pid(?MODULE), 'now').

%% now_seconds()->
%%     gen_server:call(misc:get_global_pid(?MODULE), 'now_seconds').

get_time1()->
    gen_server:call(misc:get_global_pid(?MODULE), 'get_time1').

get_time2()->
    gen_server:call(misc:get_global_pid(?MODULE), 'get_time2').

get_time3()->
    gen_server:call(misc:get_global_pid(?MODULE), 'get_time3').


%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
init([]) ->
    NowTime = erlang:timestamp(),
    Ref = erlang:send_after(?Time, self(), 'one_second'),
    State = #state{now_time = NowTime, time_ref = Ref},
    {ok, State}.

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
%% 获取现在的时间
do_handle_call('now', _From, State)->
    {reply, State#state.now_time, State};

do_handle_call('get_time1', _From, State)->
    {reply, State#state.now_time, State};

do_handle_call('get_time2', _From, State)->
    {reply, erlang:timestamp(), State};

do_handle_call('get_time3', _From, State)->
    {reply, os:timestamp(), State};

do_handle_call(_Request, _From, State)->
    {reply, ok, State}.

do_handle_cast(_Msg, State)->
    {noreply, State}.

do_handle_info('one_second', State)->
    NowTime = erlang:timestamp(),
    Ref = erlang:send_after(?Time, self(), 'one_second'),
    {noreply, State#state{now_time = NowTime, time_ref = Ref}};

do_handle_info(_Info, State)->
    {noreply, State}.
