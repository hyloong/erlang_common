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

%% 
for(Max, Max, F)-> F();
for(I, Max, F)-> 
    F(),
    for(I+1, Max, F).
    

to_float(Float, Sub) when is_integer(Float) -> 
    F = float_to_binary(float(Float), [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, Sub) when is_float(Float) ->
    F = float_to_binary(Float, [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, _) -> 
    ?ERR("~p~n", [Float]),
    Float.

%% 测试 r17
%% +sub false|true：每个cpu都能动起来，实现负载均衡
%% +scl false|true：优先让低Id的忙碌起来，如果不够，就让高位的cpu加入
fib(0) -> 1;  
fib(1) -> 1;  
fib(N) -> fib(N-1) + fib(N-2).  
busy()-> fib(10), busy(). 


get_time()->
    erlang:now().


test_use_other_mod_fun(N)->
    {T1, _} = timer:tc(util, test_use_other_mod_fun1, [N, self()]),
    io:format("~p ~p T2=~w~n", [?MODULE, ?LINE, T1]).

test_use_other_mod_fun1(0, _Pid) ->ok;
test_use_other_mod_fun1(N, Pid) ->
    ptool:fib(10),
    test_use_other_mod_fun1(N-1, Pid).




