%%--------------------------------------------
%% @Module	:	db_app
%% @Author	:	ycg
%% @Email	:	
%% @Created	:	2014.06.24
%% @Description	:	db应用行为模式
%%--------------------------------------------
-module(db_app).
-behaviour(application).
-export([start/0, start/2, stop/1]).

start() ->
	application:start(db).

start(_StartType, _StartArgs) ->
	io:format("~p~n", application:get_env(test, db_user)),
	case db_sup:start_link() of
		{ok, Pid} ->
			{ok, Pid};
		Other ->
			{error, Other}
	end.

stop(_State) ->
	ok.
