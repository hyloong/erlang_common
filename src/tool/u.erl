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
         cu/0
        ]).

-define(NODE, 'yxyz10@192.168.5.59').
-define(CNODE, 'yxyz01@192.168.5.59').

p()->
    net_adm:ping(?NODE).

u()->
    rpc:call(?NODE, u, u, []).

cu()->
    rpc:call(?CNODE, u, remote_load, []).
    


