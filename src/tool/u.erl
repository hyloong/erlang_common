%%% @author root <root@localhost.heller>
%%% @copyright (C) 2016, root
%%% @doc
%%%
%%% @end
%%% Created :  7 Dec 2016 by root <root@localhost.heller>

-module(u).

-export([
         p/0,
         u/0,
         cu/0,
         xu/0,
         wu/0
        ]).


-define(NODE, 'yxyz10@192.168.5.49').

-define(CNODE, 'yxyz01@192.168.5.49').

%% 
-define(LNODE, 'x_kfs110@192.168.5.206').


-define(WNODE, 'x_kfs110@192.168.5.49').


p()->
    net_adm:ping(?NODE).

u()->
    rpc:call(?NODE, u, u, []).

cu()->
    rpc:call(?CNODE, u, remote_load, []).

xu()->
    rpc:call(?LNODE, u, u, []).

wu()->
    rpc:call(?WNODE, u, u, []).

    



