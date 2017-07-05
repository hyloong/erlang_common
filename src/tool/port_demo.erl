%%% @author root <root@localhost.heller>
%%% @copyright (C) 2017, root
%%% @doc
%%%
%%% @end
%%% Created : 26 Jun 2017 by root <root@localhost.heller>

-module(port_demo).


-compile(export_all).


start()->
    _ = [gen_udp:open(0) || _ <- lists:seq(1,768)],
    Port = open_port({spawn, "/bin/cat"}, [in, out, {line, 128}]),
    port_close(Port),
    ok.
