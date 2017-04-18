%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 23 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(gs_tcp_server).

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-compile(export_all).

-record(tcp_state, {lsock = [], ref = []}).

-include("common.hrl").

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
start_link(Port) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
init([Port]) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, ?TCP_OPTIONS),
    gen_server:cast(self(), accept1),
    %% gen_server:cast(self(), accept2),
    {ok, #tcp_state{lsock = ListenSocket}}.

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

do_handle_cast(accept1, State)->
    accept(State);

do_handle_cast(accept2, State)->
    spawn(fun()-> accept_loop(State#tcp_state.lsock) end),
    {noreply, State}.

do_handle_info({inet_async, LSock, Ref, {ok, Sock}}, State = #tcp_state{lsock=LSock, ref=Ref}) ->
    case set_sockopt(LSock, Sock) of
        ok -> ok;
        {error, Reason} -> exit({set_sockopt, Reason})
    end,
    spawn(fun() -> loop(Sock) end),
    accept(State);

do_handle_info({inet_async, LSock, Ref, {error, closed}}, State=#tcp_state{lsock=LSock, ref=Ref}) ->
    io:format("~p ~p {error, closed}=~p~n", [?MODULE, ?LINE, {error, closed}]),
    {stop, normal, State};

do_handle_info(_Info, State)->
    io:format("~p ~p Info=~p~n", [?MODULE, ?LINE, _Info]),
    {noreply, State}.

accept_loop(LSock) ->
    case gen_tcp:accept(LSock) of 
        {ok, Socket} ->
            spawn(fun() -> loop(Socket) end),
            %% start a client child 
            accept_loop(LSock);
        _Reason ->
            accept_loop(LSock)
    end.

set_sockopt(LSock, Sock) ->
    true = inet_db:register_socket(Sock, inet_tcp),
    case prim_inet:getopts(LSock, [active, nodelay, keepalive, delay_send, priority, tos]) of
        {ok, Opts} ->
            case prim_inet:setopts(Sock, Opts) of
                ok    -> ok;
                Error -> 
                    gen_tcp:close(Sock),
                    Error
            end;
        Error ->
            gen_tcp:close(Sock),
            Error
    end.

accept(State = #tcp_state{lsock=LSock}) ->
    case prim_inet:async_accept(LSock, -1) of
        {ok, Ref} -> 
            {noreply, State#tcp_state{ref=Ref}};
        Error     ->
            {stop, {cannot_accept, Error}, State}
    end.

loop(Socket)->
    case gen_tcp:recv(Socket, 0) of 
        {ok, Bin}->
            gen_tcp:send(Socket, Bin),
            loop(Socket);
        _Reason ->
            gen_tcp:close(Socket)
    end.
