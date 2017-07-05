%%%-----------------------------------
%%% @Module  : sd_tcp_listener_sup
%%% @Author  : xyao
%%% @Email   : jiexiaowen@gmail.com
%%% @Created : 2010.06.01
%%% @Description: tcp listerner 监控树
%%%-----------------------------------

-module(gs_tcp_listener_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).

start_link(Port) ->
    supervisor:start_link(?MODULE, {10, Port}).

%% 接收个数，端口
init({AcceptorCount, Port}) ->
    {ok,
        {{one_for_all, 10, 10},
            [
                {
                    gs_tcp_acceptor_sup, %% 开启socket接受监控进程，不会生成进程
                    {gs_tcp_acceptor_sup, start_link, []},
                    transient,
                    infinity,
                    supervisor,
                    [gs_tcp_acceptor_sup]
                },
                {
                    gs_tcp_listener, %% 开启Tcp监听者
                    {gs_tcp_listener, start_link, [AcceptorCount, Port]},
                    transient,
                    100,
                    worker,
                    [gs_tcp_listener]
                }
            ]
        }
    }.
