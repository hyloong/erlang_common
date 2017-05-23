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
-export([start/2, stop/1]).

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
            %% 日志 
            LogLevel = config:get_log_level(),
            LogPath = config:get_log_path(),
            File = filename:join(LogPath, get_file_name()),
            log_loglevel:set(LogLevel),
            error_logger:add_report_handler(log_logger_h, File),
            %% 启动mysql
            db:start(),
            %% 启动参数
            [_Ip, _Port, _NId|_] = init:get_plain_arguments(),
            NId = list_to_integer(_NId),
            if 
                NId >= 10 -> %% 游戏线
                    gs_server_base:start();
                NId == 1 -> %% 公共线
                    gs_unite_base:start();
                true -> %% 跨服
                    gs_clusters_base:start()
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
