%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 20 Mar 2017 by root <root@localhost.heller>

-module(gs_server_base).

-compile(export_all).

start(Port)->
    supervisor:start_child(
      gs_sup, {gs_server, 
                   {gs_server, start_link, []},
                   permanent, 5000, worker, [gs_server]}),

    supervisor:start_child(
      gs_sup, {gs_login_fsm, 
                   {gs_login_fsm, start_link, []},
                   permanent, 5000, worker, [gs_login_fsm]}),

    supervisor:start_child(
      gs_sup, {gs_sup_test,
                   {gs_sup_test, start_link, []},
                   permanent, 5000, supervisor, [gs_sup_test]}),

    supervisor:start_child(
      gs_sup, {gs_tcp_server,
                   {gs_tcp_server, start_link, [Port]},
                   permanent, 5000, worker, [gs_tcp_server]}),
    ok.
