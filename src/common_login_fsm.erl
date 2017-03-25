%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 20 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(common_login_fsm).

-behaviour(gen_fsm).

%% API
-export([start_link/0,
         check/2,
         wait/2, wait/3,
         add_online_count/0, add_online_count_all/0, test_all/0,
         delete_online_count/0, delete_online_count_all/0]).

%% gen_fsm callbacks
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-record(state, {timer = [], count = 0}).

%% send_event/2
%% sync_send_event/2
%% send_all_state_event/2
%% sync_send_all_state_event/2

%%%===================================================================
%%% API
%%%===================================================================

%% 异步发送事件
add_online_count()->
    gen_fsm:send_event(?MODULE, {add_online_count}).

%% 同步发送事件
delete_online_count()->
    gen_fsm:sync_send_event(?MODULE, {delete_online_count}).

%% 异步发送事件,
%% 但是不是特定某一个状态的事件，而是所有状态都可以触发的事件
add_online_count_all()->
    gen_fsm:send_all_state_event(?MODULE, {add_online_count_all}).

%% 测试是不是统同一个状态
test_all()->
    gen_fsm:send_all_state_event(?MODULE, {test_all}).

%% 同步发送事件
%% 但是不是特定某一个状态的事件，而是所有状态都可以触发的事件
delete_online_count_all()->
    gen_fsm:sync_send_all_state_event(?MODULE, {delete_online_count_all}).

%%--------------------------------------------------------------------
%% @doc
%% Creates a gen_fsm process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm is started using gen_fsm:start/[3,4] or
%% gen_fsm:start_link/[3,4], this function is called by the new
%% process to initialize.
%%
%% @spec init(Args) -> {ok, StateName, State} |
%%                     {ok, StateName, State, Timeout} |
%%                     ignore |
%%                     {stop, StopReason}
%% @end
%%--------------------------------------------------------------------
%% init([]) ->
%%     process_flag(trap_exit, true),
%%     {_H, M, _S} = erlang:time(),
%%     Time = max(3600-M*60, 1)*1000,
%%     Timer = gen_fsm:send_event_after(Time, log_to_db),
%%     {ok, wait, #state{count = 0, timer = Timer}}.

init([]) ->
    process_flag(trap_exit, true),
    %% {_H, M, _S} = erlang:time(),
    %% Time = max(3600-M*60, 1)*1000,
    Timer = gen_fsm:send_event_after(10, repeat),
    {ok, check, #state{count = 0, timer = Timer}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_event/2, the instance of this function with the same
%% name as the current state name StateName is called to handle
%% the event. It is also called if a timeout occurs.
%%
%% @spec state_name(Event, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
%% 初始化检查check
check(repeat, State)->
    %% {_H, M, _S} = erlang:time(),
    %% Time = max(3600-M*60, 1)*1000,
    Time = 20000,
    io:format("~p ~p check to wait state time=~p~n", [?MODULE, ?LINE, [Time]]),
    Timer = gen_fsm:send_event_after(Time, log_to_db),
    {next_state, wait, State#state{timer = Timer}};

%% 超时触发的状态切换
check(time_out, State) ->
    %% {_H, M, _S} = erlang:time(),
    %% Time = max(3600-M*60, 1)*1000,
    Time = 20000,
    io:format("~p ~p check to wait state time out=~p~n", [?MODULE, ?LINE, [Time]]),
    Timer = gen_fsm:send_event_after(Time, log_to_db),
    {next_state, wait, State#state{timer = Timer}}.

%% 检查后的状态wait
wait({add_online_count}, State)->
    #state{count = Count} = State,
    io:format("~p ~p add_online_count1=~p~n", [?MODULE, ?LINE, Count]),
    {next_state, wait, State#state{count = Count+1}};

%% 整点记录数据库,进入check
wait(log_to_db, State) ->
    #state{timer = OTimer, count = Count} = State,
    log_online_num(Count),
    erlang:cancel_timer(OTimer),
    Timer = gen_fsm:send_event_after(10, repeat),
    io:format("~p ~p wait to check state time =~w~n", [?MODULE, ?LINE, [10]]),
    {next_state, check, State#state{timer = Timer}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_event/[2,3], the instance of this function with
%% the same name as the current state name StateName is called to
%% handle the event.
%%
%% @spec state_name(Event, From, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------

%% 同步删除登录次数
wait({delete_online_count}, _From, State)->
    #state{count = Count} = State,
    io:format("~p ~p delete_online_count1=~p~n", [?MODULE, ?LINE, Count]),
    {next_state, {ok, 1}, wait, State#state{count = Count-1}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_all_state_event/2, this function is called to handle
%% the event.
%%
%% @spec handle_event(Event, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
handle_event({add_online_count_all}, StateName, State)->
    io:format("~p ~p _Event, StateName=~p~n", [?MODULE, ?LINE, [{add_online_count_all}, StateName]]),
    {next_state, StateName, State};

handle_event(_Event, StateName, State) ->
    io:format("~p ~p _Event, StateName=~p~n", [?MODULE, ?LINE, [_Event, StateName]]),
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_all_state_event/[2,3], this function is called
%% to handle the event.
%%
%% @spec handle_sync_event(Event, From, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------
handle_sync_event({delete_online_count_all}, _From, StateName, State) ->
    io:format("~p ~p _Event, StateName=~p~n", [?MODULE, ?LINE, [{delete_online_count_all}, StateName]]),
    Reply = ok,
    {reply, Reply, StateName, State};

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it receives any
%% message other than a synchronous or asynchronous event
%% (or a system message).
%%
%% @spec handle_info(Info,StateName,State)->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_fsm terminates with
%% Reason. The return value is ignored.
%%
%% @spec terminate(Reason, StateName, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _StateName, _State) ->
    io:format("~p ~p terminate _Reason=~p~n", [?MODULE, ?LINE, [_Reason]]),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, StateName, State, Extra) ->
%%                   {ok, StateName, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

log_online_num(State)->
    _OnlineNum = State,
    do_insert.

