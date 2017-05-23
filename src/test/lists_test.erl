%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  4 May 2017 by root <root@localhost.heller>

-module(lists_test).

-compile(export_all).

-define(L, [1,2,3,4,5,6,7,8,9,0,10]).

p(N)->
    L = lists:seq(1, N),
    [put(X, X)|| X<-L].


t(N)->
    L = lists:seq(1, N),
    {T1, _V1} = timer:tc(?MODULE, t2, [N, L]),
    io:format("~p ~p T1:~w~n", [?MODULE, ?LINE, T1]),
    {T2, _V2} = timer:tc(?MODULE, t1, [N, L]),
    io:format("~p ~p T2:~w~n", [?MODULE, ?LINE, T2]).


t1(0, _L)-> ok;
t1(N, L) ->
    A = [Player || Key <- L, Player <- [get(Key)], Player =/= []],
    io:format("~p ~p Args=~w~n", [?MODULE, ?LINE, A]),
    t1(N-1, L).

t2(0, _L) ->
     ok;
t2(N, L) ->
    F = fun(Key, Acc) ->
                case get(Key) of %% 场景进程保存
                    [] -> Acc;
                    EtsPlayer -> [EtsPlayer] ++ Acc
                end
        end,
    lists:foldl(F, [], L),
    t2(N-1, L).



tf(N)->
    L = lists:seq(1, N),
    {T1, _V1} = timer:tc(?MODULE, tf1, [L, N, [], []]),
    io:format("~p ~p T1:~w~n", [?MODULE, ?LINE, T1]),
    {T2, _V2} = timer:tc(?MODULE, tf2, [L, N, [], []]),
    io:format("~p ~p T2:~w~n", [?MODULE, ?LINE, T2]).

tf1([], _N, O, J)->
    F = fun(E) -> E > 100 end,
    _OL = lists:filter(F, O),
    _JL = lists:filter(F, J),
    ok;
tf1([E|L], N, O, J) ->
    case E rem 2 of 
        0 ->
            tf1(L, N, [E|O], J);
        _  ->
            tf1(L, N, O, [E|J])
    end.


tf2([], _N, _O, _J)->
    ok;
tf2([E|L], N, O, J) ->
    case E rem 2 of 
        0 ->
            if 
                E > 100 ->
                    tf2(L, N, [E|O], J);
                true ->
                    tf2(L, N, O, J)
            end;
        _  ->
            if 
                E > 100 ->
                    tf2(L, N, [E|O], J);
                true ->
                    tf2(L, N, O, J)
            end
    end.

tlf(N1, N2, N3)->
    L1 = [[V1, V1] || V1 <- lists:seq(1, N1)],
    L2 = [[V2, V2] || V2 <- lists:seq(N1, N2, 1)],
    L3 = [[V3, V3] || V3 <- lists:seq(N2, N3, 1)],
    D = dict:new(),
    {T1, _V1} = timer:tc(?MODULE, loop1, [L1, L2, L3]),
    io:format("~p ~p T1:~w~n", [?MODULE, ?LINE, T1]),
    %% {T2, _V2} = timer:tc(?MODULE, loop1, [L1, L2, L3, []]),
    {T2, _V2} = timer:tc(?MODULE, loop1, [L1, L2, L3, D]),
    io:format("~p ~p T2:~w~n", [?MODULE, ?LINE, T2]).

loop1(L1, L2, L3) ->
    L = L1++L2++L3,
    LL = [{K, V} || [K,V] <- L], 
    dict:from_list(LL).
    
loop1(L1, L2, L3, D)->
    D1 = loop(L1, D),
    D2 = loop(L2, D1),
    loop(L3, D2).

loop([], Dict)-> Dict;
loop([[K, V]|L], Dict)->
    loop(L, dict:store(K, {K, V}, Dict)).

%% loop1(L1, L2, L3, L)->
%%     L11 = loop(L1, L),
%%     L22 = loop(L2, L11),
%%     loop(L3, L22).

%% loop([], L)-> L;
%% loop(L, [])-> L;
%% loop([H|T], L)-> loop(T, [H|L]).

