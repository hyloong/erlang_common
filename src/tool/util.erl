%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 23 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(util).

-export([
         to_float/2
        ]).

-include("common.hrl").

to_float(Float, Sub) when is_integer(Float) -> 
    F = float_to_binary(float(Float), [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, Sub) when is_float(Float) ->
    F = float_to_binary(Float, [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, _) -> 
    ?ERR("~p~n", [Float]),
    Float.

