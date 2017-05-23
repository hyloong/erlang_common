%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 20 Mar 2017 by root <root@localhost.heller>

-module(gs_server_base).

-compile(export_all).

start()->
    
    %% 在get_main_mfas填写功能主进程信息
    MFAs = get_main_mfas(),
    misc:start_main_processes(MFAs),
    ok.
    
    %% supervisor:start_child(
    %%   gs_sup, {gs_server, 
    %%                {gs_server, start_link, []},
    %%                permanent, 5000, worker, [gs_server]}),

    %% supervisor:start_child(gs_sup,
    %%                        {mod_time, 
    %%                         {mod_time, start_link, []},
    %%                         permanent, 5000, worker, [mod_time]}),

    %% supervisor:start_child(
    %%   gs_sup, {gs_sup_test,
    %%                {gs_sup_test, start_link, []},
    %%                permanent, 5000, supervisor, [gs_sup_test]}),

    %% supervisor:start_child(
    %%   gs_sup, {gs_tcp_server,
    %%                {gs_tcp_server, start_link, [Port]},
    %%                permanent, 5000, worker, [gs_tcp_server]}),
    %% ok.

%% 功能主进程填写
%% 格式：
%% [
%%   {Mod, Fun, Args}| {Mod, Args}| M
%% ].
get_main_mfas()->
    [

    ].
