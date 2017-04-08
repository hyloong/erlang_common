%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 23 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(util).


-compile(export_all).

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

tsmg(N) ->
    {T1, _V1} = timer:tc(util, smg, [N]),
    {T2, _V2} = timer:tc(util, smg, [N]),
    io:format("~p ~p T1, T2=~p~n", [?MODULE, ?LINE, [T1, T2]]).
    

smg(0) -> common_server:test_info();
smg(N)->
    common_server:test_info(),
    smg(N-1).

smg1(0) -> common_test1:test_info();
smg1(N)->
    common_test1:test_info(),
    smg1(N-1).    


%% 测试 r17
%% +sub false|true：每个cpu都能动起来，实现负载均衡
%% +scl false|true：优先让低Id的忙碌起来，如果不够，就让高位的cpu加入
fib(0) -> 1;  
fib(1) -> 1;  
fib(N) -> fib(N-1) + fib(N-2).  
busy()-> fib(10), busy(). 


get_time()->
    erlang:now().


