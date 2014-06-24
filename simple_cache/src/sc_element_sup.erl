%%---------------------------------------------
%% @Module	:	sc_element_sup
%% @Author	:	ycg
%% @Email	:	
%% @Created	:	2014.06.23
%% @Description	:	数据管理进程监督树
%%---------------------------------------------
-module(sc_element_sup).
-behaviour(supervisor).
-export(
	[
		start_link/0,
		start_child/2
	]
).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Value, LeaseTime) ->
	supervisor:start_child(?MODULE, [Value, LeaseTime]).

init([]) ->
	Element = 	{
					sc_element,
					{sc_element, start_link, []},
					temporary,
					brutal_kill,
					worker,
					[sc_element]
				},
	Children = [Element],
	RestartStrategy = {simple_one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.

