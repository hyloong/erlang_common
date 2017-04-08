%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 28 Mar 2017 by root <root@localhost.heller>

-module(ptool).

-export([pinfo/2]).

-compile(export_all).

-define(PALL, [?PMETA, ?SIGNALS, ?LOCATION, ?MEMORY_USED, ?WORK]).
-define(PMETA, [registered_name, dictionary, group_leader, status]).
-define(SIGNALS, [links, monitors, monitored_by, trap_exit]).
-define(LOCATION, [initial_call, current_stacktrace]).
-define(MEMORY_USED, [memory, message_queue_len, heap_size, total_heap_size, garbage_collection]).
-define(WORK, [reductions]).

%% erlang process info
pinfo(PidTerm, all)->
    Keys = lists:flatten(?PALL),
    info_type(PidTerm, all, Keys);
pinfo(PidTerm, meta) ->
    info_type(PidTerm, meta, ?PMETA);
pinfo(PidTerm, signals) ->
    info_type(PidTerm, signals, ?SIGNALS);
pinfo(PidTerm, location) ->
    info_type(PidTerm, location, ?LOCATION);
pinfo(PidTerm, mem_used) ->
    info_type(PidTerm, memory_used, ?MEMORY_USED);
pinfo(PidTerm, work) ->
    info_type(PidTerm, work, ?WORK);
pinfo(PidTerm, Keys) ->
    info_type(PidTerm, other, Keys).

info_type(PidTerm, Type, Keys) ->
    case term_to_pid(PidTerm) of 
        Pid when is_pid(Pid) ->
            {Type, proc_info(Pid, Keys)};
        Res ->
            io:format("~p ~p Error Pid=~p~n", [?MODULE, ?LINE, Res])
    end.
    
proc_info(Pid, Term) when is_atom(Term) ->
    erlang:process_info(Pid, Term);
proc_info(Pid, List) when is_list(List) ->
    erlang:process_info(Pid, List).

%% pid
term_to_pid(Pid) when is_pid(Pid) -> Pid;
term_to_pid(Name) when is_atom(Name) -> whereis(Name);
term_to_pid(List = "<0."++_) -> list_to_pid(List);
term_to_pid({global, Name}) -> global:whereis_name(Name);
term_to_pid({via, Module, Name}) -> Module:whereis_name(Name);
term_to_pid({X,Y,Z}) when is_integer(X), is_integer(Y), is_integer(Z) -> triple_to_pid(X,Y,Z);
term_to_pid(_Other) -> throw({unexpect_pid, _Other}).

triple_to_pid(X, Y, Z) ->
    list_to_pid("<" ++ integer_to_list(X) ++ "." ++ integer_to_list(Y) ++ "." ++ integer_to_list(Z) ++ ">").

%% get some_att top n
top_pinfo(Type, N)->
    do.


test_my_mod_fun(N)->
    {T1, _} = timer:tc(ptool, test_use_mod_fun1, [N, self()]),
    io:format("~p ~p T1=~w~n", [?MODULE, ?LINE, T1]).

test_use_mod_fun1(0, _Pid) ->ok;
test_use_mod_fun1(N, Pid) ->
    %% pinfo(Pid, all),
    fib(10),
    test_use_mod_fun1(N-1, Pid).


fib(0) -> 1;  
fib(1) -> 1;  
fib(N) -> fib(N-1) + fib(N-2).
