-module(hi).
-export([do/0]).

do()->
    %% preloaded 预加载
    [ turn(M, P)|| {M, P} <- code:all_loaded(), P=/=preloaded].

turn(M, P) ->
    P1 = binary_to_list(iolist_to_binary(re:replace(filename:join(
                                                      %% 目录路径去掉文件名P = path
                                                      filename:dirname(P),
                                                      %% 
                                                      filename:basename(P, ".beam")), "ebin", "src"))),
    L = M:module_info(),
    COpts = get_compile_options(L),

    COpts1 = lists:foldr(fun({K, V}, Acc) when is_list(V) and is_integer(hd(V)) ->[{K, tr(V)}] ++ Acc ; (Skip, Acc) -> Acc ++ [Skip] end, [], COpts),
    io:format("~p ~p Args=~p~n", [?MODULE, ?LINE, [COpts1]]).
    %% c:c(P1, COpts1 ++ [native, "{hipe, [o3]}"]).

tr(P)->
    binary_to_list(iolist_to_binary(re:replace(P, "/net/isildur/ldisk/daily_build/otp_prebuild_r13b01.2009-06-07_20/", "/home/yufeng/"))).  %%%这个地方要根据实际情况调整 具体的参看 m(lists).

get_compile_options(L) ->
    case get_compile_info(L, options) of
        {ok,Val} -> Val;
        error -> []
    end.

get_compile_info(L, Tag) ->
    case lists:keysearch(compile, 1, L) of
        {value, {compile, I}} ->
            case lists:keysearch(Tag, 1, I) of
                {value, {Tag, Val}} -> {ok,Val};
                false -> error
            end;
        false -> error
    end.
