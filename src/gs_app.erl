%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 22 Jan 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(gs_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start_main_processes/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @spec start(StartType, StartArgs) -> {ok, Pid} |
%%                                      {ok, Pid, State} |
%%                                      {error, Reason}
%%      StartType = normal | {takeover, Node} | {failover, Node}
%%      StartArgs = term()
%% @end
%%--------------------------------------------------------------------
start(_StartType, _StartArgs) ->
    case gs_sup:start_link() of
        {ok, Pid} ->
            %% 启动日志 
            LogLevel = config:get_log_level(),
            LogPath = config:get_log_path(),
            File = filename:join(LogPath, get_file_name()),
            log_loglevel:set(LogLevel),
            error_logger:add_report_handler(log_logger_h, File),
            %% 启动参数
            [Ip, _Port, _NId|_] = init:get_plain_arguments(),
            Port = list_to_integer(_Port),
            NId = list_to_integer(_NId),
            if 
                NId >= 10 -> gs_server:start([Ip, Port, NId]);
                NId == 1  -> gs_unite:start([Ip, Port, NId]);
                true      -> gs_clusters:start([Ip, Port, NId])
            end,
            {ok, Pid};
        Error ->
            Error
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @spec stop(State) -> void()
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
get_file_name()->
    {{Y,M,D},_} = calendar:local_time(),
    lists:concat(["sys_alarm_", Y, "_", M, "_", D, ".txt"]).

%% 功能主进程启动函数
start_main_processes([]) ->
    %% util:errlog("~p ~p all main process start ok~n", [?MODULE, ?LINE]);
    ok;
start_main_processes([{M, F, A}|MFAs]) when is_atom(M), is_atom(F), is_list(A)->
    start_process(M, F, A),
    start_main_processes(MFAs);
start_main_processes([{M, A}|MFAs]) when is_atom(M), is_list(A)->
    start_process(M, start_link, A),
    start_main_processes(MFAs);
start_main_processes([M|MFAs]) when is_atom(M)-> 
    start_process(M, start_link, []),
    start_main_processes(MFAs);
start_main_processes([M|MFAs]) -> 
    util:errlog("~p ~p error main process mod=~p~n", [?MODULE, ?LINE, M]),
    start_main_processes(MFAs).

start_process(M, F, A)->
    _T = util:longunixtime(),
    Child = {M, {M, F, A}, permanent, 10000, worker, [M]},
    {ok, _} = supervisor:start_child(gs_sup, Child),
    case util:longunixtime() - _T >= 100 of
        true -> util:errlog("~p ~p T =~w~n", [?MODULE, ?LINE, util:longunixtime() - _T]);
        _ -> skip
    end,
    ok.

