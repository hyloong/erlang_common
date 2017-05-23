%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 19 Apr 2017 by root <root@localhost.heller>

-module(test_unit).
-compile(export_all).

%% 测试进程为递归的堆栈大小
t1() ->
    Pid = spawn(fun()-> do_t1() end),
    send_msg(Pid, 100000).

t2() ->
    Pid = spawn(fun()-> do_t2() end),
    send_msg(Pid, 100000).

send_msg(_Pid, 0) ->
    ok;
send_msg(Pid, N) ->
    Pid ! <<2:(N)>>,
    timer:sleep(200),
    send_msg(Pid, N-1).

do_t1() ->
    erlang:garbage_collect(self()),
    Result =erlang:process_info(self(), [memory, garbage_collection]),
    io:format("~w~n", [Result]),
    io:format("backtrace:~w~n~n",[erlang:process_display(self(), backtrace)]),
    try
        receive
            _->
                do_t1()
        end
    catch
        _:_ ->
            do_t1()
    end.

do_t2() ->
    erlang:garbage_collect(self()),
    Result =erlang:process_info(self(), [memory, garbage_collection]),
    io:format("~w~n", [Result]),
    io:format("backtrace:~w~n~n",[erlang:process_display(self(), backtrace)]),
    receive
        _ ->
            do_t2()
    end.


%%% ====================================== 测试r17的系统参数 =====================================
%% r17
%% +sub false|true：每个cpu都能动起来，实现负载均衡
%% +scl false|true：优先让低Id的忙碌起来，如果不够，就让高位的cpu加入
fib(0) -> 1;  
fib(1) -> 1;  
fib(N) -> fib(N-1) + fib(N-2).  
busy()-> fib(10), busy().


%% 
param_default(Type)->
    Five = if 
               Type == 1 -> 5; 
               true -> 0
           end,
    Five.


param_default1(Type)->
    if 
        Type == 1 -> Five =  5; 
        true -> Five = 0
    end,
    Five.

