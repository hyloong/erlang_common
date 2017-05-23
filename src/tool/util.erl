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

%% 信息记录
errlog(F, A) -> ?DEBUG(F, A).
errlog(test, F, A)-> ?DEBUG(F, A);
errlog(info, F, A) -> ?INFO(F, A);
errlog(warn, F, A) -> ?WARN(F, A);
errlog(err, F, A) -> ?ERR(F, A);
errlog(crit, F, A) -> ?CRITICAL(F, A);
errlog(_, F, A) -> ?DEBUG(F, A).
    
%% for循环
for(Max, Max, F)-> F(Max);
for(I, Max, F)-> F(I), for(I+1, Max, F).

for(Max, Max, F, State)-> F(Max, State);
for(I, Max, F, State)-> for(I+1, Max, F, F(I, State)).

%% 浮点数精度
to_float(Float, Sub) when is_integer(Float) -> 
    F = float_to_binary(float(Float), [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, Sub) when is_float(Float) ->
    F = float_to_binary(Float, [{decimals, Sub}]),
    binary_to_float(F);
to_float(Float, _) -> 
    ?ERR("to float error:~p~n", [Float]),
    Float.
