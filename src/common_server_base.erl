%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 20 Mar 2017 by root <root@localhost.heller>

-module(common_server_base).

-compile(export_all).

start()->
    supervisor:start_child(
      common_sup, {common_server, 
                   {common_server, start_link, []},
                   permanent, 5000, worker, [common_server]}),
    
    supervisor:start_child(
      common_sup, {common_login_fsm, 
                   {common_login_fsm, start_link, []},
                   permanent, 5000, worker, [common_login_fsm]}),
    
    supervisor:start_child(
      common_sup, {common_sup_test,
                   {common_sup_test, start_link, []},
                   permanent, 5000, supervisor, [common_sup_test]}),    
    ok.
