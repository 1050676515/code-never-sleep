-module(test).
-compile(export_all).


start() ->
	lists:foreach(fun(Num) ->
			spawn(fun() -> test(Num, 2345) end)
	end, lists:seq(1, 100)).

test(Num, Port) ->
	case gen_tcp:connect("127.0.0.1", Port, [binary, {packet, 4}]) of
		{ok, _} ->
			io:format("~p~n", [Num]),
			receive
				_Any ->
					io:format("Any: ~p~n", [_Any])
			end;
		_ ->
			io:format("error~n")
	end.