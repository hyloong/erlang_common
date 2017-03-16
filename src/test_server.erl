%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  3 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(test_server).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
start_link(Args) ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [Args], []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
init([Args]) ->
    [{from_pid, Pid}] = Args,
    Pid ! {set_test_pid, self()},
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

do_handle_cast(_Msg, State)->
    {noreply, State}.

do_handle_info(_Info, State)->
    {noreply, State}.
