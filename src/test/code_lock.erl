-module(code_lock).
-define(NAME, code_lock).
-export([start_link/1,button/1]).

start_link(Code) ->
spawn(fun () -> true = register(?NAME, self()), do_lock(), locked(Code, Code) end).

button(Digit) -> ?NAME ! {button,Digit}.

locked(Code, [Digit|Remaining]) ->
   io:format("~p ~p ~n", [{?MODULE,?LINE}, Digit]),	
   receive
      {button,Digit} when Remaining =:= [] ->
          do_unlock(),
          open(Code);
      {button,Digit} ->
          locked(Code, Remaining);
      {button,_} ->
          locked(Code, Code)
  end.

open(Code) ->
   receive
   after 10000 ->
      do_lock(),
      locked(Code, Code)
   end.

do_lock() -> io:format("Locked~n", []).
do_unlock() -> io:format("Open~n", []).
