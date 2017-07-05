%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 22 Jan 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(gs_server).

%% API
-export([start/1, stop/0]).

-include("common.hrl").

%% 启动游戏线功能
start([Ip, Port, Nid]) ->
    start_client(),
    start_tcp(Port),
    MFAs = get_main_mfas(),
    gs_app:start_main_processes(MFAs),
    do.

stop()->
    ok.



%% 开启客户端监控树
start_client() ->
    {ok,_} = supervisor:start_child(
               gs_sup,
               {gs_tcp_client_sup,
                {gs_tcp_client_sup, start_link,[]},
                transient, infinity, supervisor, [gs_tcp_client_sup]}),
    ok.


%%开启tcp listener监控树，进程池
start_tcp(Port) ->
    {ok,_} = supervisor:start_child(
               gs_sup,
               {gs_tcp_listener_sup,
                {gs_tcp_listener_sup, start_link, [Port]},
                transient, infinity, supervisor, [gs_tcp_listener_sup]}),
    ok.


%% 功能进程
get_main_mfas()->
    [].
