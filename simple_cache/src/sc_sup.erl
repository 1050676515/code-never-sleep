%%--------------------------------------------
%% @Module	:	sc_sup
%% @Author	:	ycg
%% @Email	:
%% @Created	:	2014.06.24
%% @Description	:	缓存系统根监控树
%%--------------------------------------------
-module(sc_sup).
-behaviour(supervisor).

-export(
	[
		start_link/0,
		init/1
	]
).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	ElementSup = 	{
						sc_element_sup,
						{sc_element_sup, start_link, []},
						permanent,
						infinity,
						supervisor,
						[sc_element_sup]
	},
	EventManager =	{
						sc_event,
						{sc_event, start_link, []},
						permanent,
						2000,
						worker,
						[sc_event]
	},
	Children = [ElementSup, EventManager],
	RestartStrategy = {one_for_one, 4, 3600},
	{ok, {RestartStrategy, Children}}.