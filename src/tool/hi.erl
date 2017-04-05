%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%  
%%% @end 
%%% Created : 17 Mar 2017 by root <root@localhost.heller>

-module(hi).

-export([do/0, do/1]).

do()->
    %% preloaded 预加载
    [turn(M, P)|| {M, P} <- code:all_loaded(), P=/=preloaded].

do(Mod) ->
    [turn(M, P) || {M, P} <- code:all_loaded(), M == Mod].
    

turn(M, P) ->
    P1 = binary_to_list(iolist_to_binary(re:replace(filename:join(
                                                      %% 目录路径去掉文件名P = path
                                                      filename:dirname(P),
                                                      %% 
                                                      filename:basename(P, ".beam")), "ebin", "src"))),
    L = M:module_info(),
    COpts = get_compile_options(L),
    COpts1 = lists:foldr(
               fun({K, V}, Acc) when is_list(V) and is_integer(hd(V)) ->
                       [{K, tr(V)}] ++ Acc ; (Skip, Acc) -> Acc ++ [Skip]
               end,
               [], COpts),
    %% c:c(P1, COpts1 ++ [native, "{hipe, [o3]}"]).
    io:format("~p ~p Args=~p~n", [?MODULE, ?LINE, [COpts1]]),
    c:c(P1, COpts1).
    
tr(P)->
    %% [{outdir,"/root/Downloads/otp_src_R16B03-1/lib/stdlib/src/../ebin"},
    %%  {i,"/root/Downloads/otp_src_R16B03-1/lib/stdlib/src/../include"},
    %%  {i,"/root/Downloads/otp_src_R16B03-1/lib/stdlib/src/../../kernel/include"},
    %%  warnings_as_errors,debug_info]
    %% io:format("~p ~p P=~p~n", [?MODULE, ?LINE, P]),
    A = binary_to_list(iolist_to_binary(re:replace(P, "/root/Downloads/otp_src_R16B03-1/lib/stdlib/src/../ebin", "/root/erlang_ebin"))),  %%%这个地方要根据实际情况调整 具体的参看 m(lists).
    %% io:format("~p ~p A=~p~n", [?MODULE, ?LINE, A]),
    A.

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
