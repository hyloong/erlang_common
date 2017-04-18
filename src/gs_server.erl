%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 22 Jan 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(gs_server).

-behaviour(gen_server).

%% API
-export([start_link/0, test_info/1]).

-compile(export_all).

-include("common.hrl").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server2:start_link({local, ?SERVER}, ?MODULE, [], []).

test_info(0)->
    gen_server2:cast(?MODULE, {sum, 10}),
    %% ?DEBUG("ProcessInfo:~p~n", [erlang:process_info(whereis(?MODULE))]),
    ok;
test_info(N)->
    gen_server2:cast(?MODULE, {sum, 10}),
    test_info(N-1).

get_pid()->
    gen_server2:call(?MODULE, {get_pid}).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    %% db_sql:start_link(),
    timer:sleep(1000),
    %% {ok, State, Timeout, Backoff = {backoff, _, _, _}}
    {ok, #state{}, hibernate, {backoff, 1000, 1000, 1000}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_call({get_pid}, _From, State) ->
    Reply = self(),
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({sum, Num}, State)->
    %% timer:sleep(2000),
    Reply = sum(Num),
    io:format("~p ~p Reply=~p~n", [?MODULE, ?LINE, Reply]),
    {noreply, State, hibernate};
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    io:format("~p ~p Args=~p~n", [?MODULE, ?LINE, _Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}%
% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_pre_hibernate(State) ->
    {hibernate, State}.

%% {noreply, NState}| {noreply, NState, Time}
handle_post_hibernate(State) ->
    {noreply, State}.

%% 设置执行优先级
prioritise_call(_Msg, _From, _Len, _State) -> 0.

prioritise_cast(_Msg, _Len, _State) -> 0.

prioritise_info(_Msg, _Len, _State) -> 0.
    

%%%===================================================================
%%% Internal functions
%%%===================================================================
sum(Num)-> sum(Num, 0).
sum(0, T) -> T;
sum(Num, T)-> sum(Num-1, T+Num).
    
