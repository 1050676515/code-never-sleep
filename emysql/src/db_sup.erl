%%--------------------------------------------
%% @Module	:	db_sup
%% @Author	:	ycg
%% @Email	:
%% @Created	:	2014.06.24
%% @Description	:	db监控树
%%--------------------------------------------
-module(db_sup).
-behaviour(supervisor).
-export([
	start_link/0,
	init/1
]).


start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	Children = {
					db,
					{db, start_link, []},
					transient,
					2000,
					worker,
					[db]
	},
	RestartStrategy = {one_for_one, 4, 3600},
	{ok, {RestartStrategy, [Children]}}.
