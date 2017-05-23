%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  2 May 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(misc).

-export([
         get_global_pid/1
        ]).


get_global_pid(Name)->
    global:whereis_name(Name).
