%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created :  2 May 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(time_test).

-export([
         t/1
        ]).

-compile(export_all).

t(N)->
    {T1, _V1} = timer:tc(time_debug, get_time1, [N]),
    {T2, _V2} = timer:tc(time_debug, get_time2, [N]),
    {T3, _V3} = timer:tc(time_debug, get_time3, [N]),
    io:format("~p ~p [T1, T2, T3]=~w~n", [?MODULE, ?LINE, [T1, T2, T3]]).
    
get_time1(0)-> ok;
get_time1(N)->
    mod_time:get_time1(),
    get_time1(N-1).


get_time2(0)-> ok;
get_time2(N)->
    %% mod_time:get_time2(),
    %% 多个进程读取会产生很多锁操作
    erlang:now(),
    get_time2(N-1).


get_time3(0)-> ok;
get_time3(N)->
    %% mod_time:get_time3(),
    os:timestamp(),
    get_time3(N-1).
    

%% ++：长度小的列表放在前面
%% addt(N, M)->
%%     L1 = lists:seq(1, N),
%%     L2 = lists:seq(1, M),
%%     {T1, _V1} = timer:tc(?MODULE, add_t, [L1, L2]),
%%     {T2, _V2} = timer:tc(?MODULE, add_t, [L2, L1]),
%%     io:format("~p ~p T1:~w~n", [?MODULE, ?LINE, T1]),
%%     io:format("~p ~p T2:~w~n", [?MODULE, ?LINE, T2]).

%% add_t(L1, L2)->
%%     %% L1 ++ L2. ++ 与 append实际一样
%%     lists:append(L1, L2).



%% t(PlayerList) ->
%%     %% F = fun(Key, Acc) ->
%%     %%             case lib_scene_agent:get_user(Key) of %% 场景进程保存
%%     %%                 [] -> Acc;
%%     %%                 EtsPlayer -> [EtsPlayer] ++ Acc
%%     %%             end
%%     %%     end,
%%     %% lists:foldl(F, [], PlayerList),
%%     [Player || Key <- PlayerList, Player <- [lib_scene_agent:get_user(Key)], Player =/= []].    
