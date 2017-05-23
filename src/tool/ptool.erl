%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%% erlang process info api
%%% something from recon app, thanks!
%%% @end
%%% Created : 11 Apr 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(ptool).

%% erlang process attr
-define(META, [registered_name, dictionary, group_leader, status]).
-define(SIGNALS, [links, monitors, monitored_by, trap_exit]).
-define(LOCATION, [initial_call, current_stacktrace]).
-define(MEM_USED, [memory, message_queue_len, heap_size, total_heap_size, garbage_collection]).
-define(WORK, [reductions, current_function]).
-define(COUNTATTER, [registered_name, current_function, initial_call]).

%% 查看进程的信息
-export([pinfo/2]).

-compile(export_all).

%% ========================================= 获取进程信息 ========================================
pinfo(Pid, Type) ->
    P = term_to_pid(Pid),
    epinfo(P, Type).

epinfo(Pid, Type)->
    LocalNode = node(),
    case node(Pid) of 
        LocalNode ->
            info(Type, Pid);
        RemoteNode ->
            rpc:call(RemoteNode, ptool, pinfo, [Pid, Type])
    end.

info(meta, Pid)->
    [{meta, [erlang:process_info(Pid, X) || X <- ?META]}];
info(sign, Pid) ->
    [{sign, [erlang:process_info(Pid, X) || X <- ?SIGNALS]}];
info(location, Pid) ->
    [{location, [erlang:process_info(Pid, X) || X <- ?LOCATION]}];
info(mem, Pid) ->
    [{mem, [erlang:process_info(Pid, X) || X <- ?MEM_USED]}];
info(work, Pid) ->
    [{work, [erlang:process_info(Pid, X) || X <- ?WORK]}];
info(all, Pid) ->
    [{all, erlang:process_info(Pid)}];
info(Type, Pid) ->
    [{Type, catch erlang:process_info(Pid, Type)}].

%% to pid
term_to_pid(Pid) when is_pid(Pid) -> Pid;
term_to_pid(Name) when is_atom(Name) -> whereis(Name);
term_to_pid(List = "<0."++_) -> list_to_pid(List);
term_to_pid({global, Name}) -> global:whereis_name(Name);
term_to_pid({via, Module, Name}) -> Module:whereis_name(Name);
term_to_pid({X,Y,Z}) when is_integer(X), is_integer(Y), is_integer(Z) -> 
    list_to_pid("<" ++ integer_to_list(X) ++ "." ++ integer_to_list(Y) ++ "." ++ integer_to_list(Z) ++ ">").


%% ========================================= 进程属性最高的n条排序 ======================================== 
%% pcount(Type, Num) ->
%%     Pids = [erlang:processes()],
%%     Attr = [Type|?COUNTATTER],
%%     PInfos = [ Attrs || Pid <- Pids, {} =  proc_attrs(Attr, Pid)],
%%     sublist_top_n(proc_attrs(AttrName), Num).



%% @private Returns the top n element of List. n = Len
sublist_top_n(List, Len) ->
    pheap_fill(List, Len, []).

%% 选择排序算法
%% 头部填充
pheap_fill(List, 0, Heap) ->
    pheap_full(List, Heap);

pheap_fill([], 0, Heap) ->
    pheap_to_list(Heap, []);

pheap_fill([{Y, X, _} = H|T], N, Heap) ->
    NewHeap = insert({{X, Y}, H}, Heap), %% 保证第一个元素是最小
    pheap_fill(T, N-1, NewHeap).

pheap_full([], Heap) ->
    pheap_to_list(Heap, []);
pheap_full([{Y, X, _} = H|T], [{K, _}|HeapT] = Heap) ->
    case {X, Y} of
        N when N > K ->
            pheap_full(T, insert({N, H}, merge_pairs(HeapT)));
        _ ->
            pheap_full(T, Heap)
    end.

pheap_to_list([], Acc) -> Acc;
pheap_to_list([{_, H}|T], Acc) ->
    pheap_to_list(merge_pairs(T), [H|Acc]).

%% 内联函数，类似宏定义
-compile({inline, [insert/2, merge/2]}).

insert(E, []) -> [E];
insert(E, [E2|_] = H) when E =< E2 -> [E, H];
insert(E, [E2|H]) -> [E2, [E]|H].

merge(H1, []) -> H1;
merge([E1|H1], [E2|_]=H2) when E1 =< E2 -> [E1, H2|H1];
merge(H1, [E2|H2]) -> [E2, H1|H2].

merge_pairs([]) -> [];
merge_pairs([H]) -> H;
merge_pairs([A, B|T]) -> merge(merge(A, B), merge_pairs(T)).

%% ========================================= gc进程 ========================================
