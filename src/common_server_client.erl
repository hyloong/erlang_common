%%%-------------------------------------------------------------------
%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 23 Mar 2017 by root <root@localhost.heller>
%%%-------------------------------------------------------------------
-module(common_server_client).
-compile(export_all).

start()->
    register(client, 
             spawn(fun() -> 
                           case gen_tcp:connect("127.0.0.1", 5200, [binary, {packet, 0}, {active, false}]) of 
                               {ok, Socket} ->
                                   gen_tcp:send(Socket, <<"nihao">>),
                                   spawn(fun() -> loop(Socket) end),
                                   loop_msg(Socket);
                               _Reason ->
                                   io:format("~p ~p Connet _Reason=~p~n", [?MODULE, ?LINE, [_Reason]]),
                                   ok 
                           end
                   end)
            ).

send_msg(Msg)->
    client ! Msg.

%% 进程接受消息
loop_msg(Socket)->
    receive 
        {heller, Data}->
            Bin = list_to_binary(Data),
            gen_tcp:send(Socket, Bin),
            loop_msg(Socket);
        Msg ->
            io:format("~p ~p Msg=~p~n", [?MODULE, ?LINE, Msg]),
            loop_msg(Socket)
    end.

%% socket接受消息
loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of 
        {ok, Bin}->
            io:format("~p ~p Bin=~p~n", [?MODULE, ?LINE, [Bin]]),
            loop(Socket);
        _Reason ->
            gen_tcp:close(Socket)
    end.
