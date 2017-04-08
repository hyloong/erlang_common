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



test_smsg()->
    do.


test_smsg(Name, N)->
    String = "我不是假的，我是真的来测试数据的怎么样？是不是据的很惊讶，但是你不必惊讶，因为那是琼鱼告诉我一定要作的，大鱼海棠，这是石么，好看，我感觉还好，周末约看电影吗？还是算了，决定在家里学习包子！是不是很逗，应该是。天都快给你聊死了！！！好了，就这样吧，五一还是回家好，我已经许久没有回家了。",
    F = fun() ->
                spawn(fun() -> rpc:cast(Name, util, test_smsg, [String]) end)
        end,
    for(1, N, F).





