%%--------------------------------------------
%% @Module	:	sc_app
%% @Author	:	ycg
%% @Email	:	
%% @Created	:	2014.06.23
%% @Description	:	缓存系统应用行为模式
%%--------------------------------------------
-module(sc_app).
-behaviour(application).
-export([start/1, start/2, stop/1]).

start([_StartType, _StartArgs]) ->
	application:start(simple_cache).

start(_StartType, _StartArgs) ->
	sc_store:init(),
	case sc_sup:start_link() of
		{ok, Pid} ->
			sc_event_logger:add_handler(),
			{ok, Pid};
		Other ->
			{error, Other}
	end.

stop(_State) ->
	ok.