%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 16 May 2017 by root <root@localhost.heller>

-module(config).


-compile(export_all).


%% 日志系统配置文件
get_log_level() ->
    case application:get_env(gs, log_level) of
	{ok, LogLevel} -> LogLevel;
	_ -> 3
    end.

get_log_path() ->
    case application:get_env(gs, log_path) of
	{ok, LogPath} -> LogPath;
	_ -> "gs_alarm.log"
    end.

%% 私钥
get_ticket() ->
    case application:get_env(gs, ticket) of
	{ok, Ticket} -> Ticket;
	_ -> "ticket"
    end.

%% 获取服务器id
%% 格式如：合服前["S1"] 或 合服后["S1", "S2"]
get_server_id() ->
    case application:get_env(gs, card_server) of
	    {ok, _Ser} -> _Ser;
        _ -> []
    end.

%% 获取新手卡
get_card() ->
    Key = case application:get_env(gs, card_key) of
	{ok, _Key} -> _Key;
	_ -> "key"
    end,

    Ser = case application:get_env(gs, card_server) of
	{ok, _Ser} -> _Ser;
    _ -> []
    end,
    {Key, Ser}.

%% 手机钱包开关(0关，1开)
get_phone_gift() ->
    case application:get_env(gs, phone_gift) of
	{ok, Gift} -> Gift;
	_ -> 0
    end.


%% 获取mysql参数
get_mysql() ->
    Host1 = case application:get_env(gs, db_host) of
	{ok, Host} -> Host;
	_ -> "localhost"
    end,
    Port1 = case application:get_env(gs, db_port) of
	{ok, Port} -> Port;
	_ -> 3306
    end,
    User1 = case application:get_env(gs, db_user) of
	{ok, User} -> User;
	_ -> "root"
    end,
    Pass1 = case application:get_env(gs, db_pass) of
	{ok, Pass} -> Pass;
	_ -> "root"
    end,
    Name1 = case application:get_env(gs, db_name) of
	{ok, Name} -> Name;
	_ -> "test"
    end,
    Encode1 = case application:get_env(gs, db_encode) of
	{ok, Encode} -> Encode;
	_ -> utf8
    end,
    ConnectNum1 = case application:get_env(gs, db_connect_num) of
    {ok, ConnectNum} when is_integer(ConnectNum)-> ConnectNum;
	_ -> 75
    end,
    [Host1, Port1, User1, Pass1, Name1, Encode1, ConnectNum1].
