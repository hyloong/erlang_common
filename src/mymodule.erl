%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  8 Apr 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(mymodule).

-export([load/0, findPrime/1]).

load()->
    erlang:load_nif("../c_src/mymodule", 0).


findPrime(N) ->  
    io:format("this function is not defined!~n").
