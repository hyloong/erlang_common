%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 19 Apr 2017 by root <root@localhost.heller>

-module(cpu_intensive).

-compile(export_all).

fib_test() ->
    fib(40),
    fib(40),
    fib(40).

fib(0) -> 1;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).
