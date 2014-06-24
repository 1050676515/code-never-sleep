%%-----------------------------------------------------------
%% @Module	:	sc_event_logger
%% @Author	:	ycg
%% @Email	:
%% @Created	:	2014.06.24
%% @Description	:	自定义事件流
%%-----------------------------------------------------------
-module(sc_event_logger).
-behaviour(gen_event).
-export(
	[
		add_handler/0,
		delete_handler/0
	]
).

-export(
	[
		init/1,
		handle_event/2,
		handle_call/2,
		handle_info/2,
		code_change/3,
		terminate/2
	]
).

%%----------------------------------------------
%% API
%%----------------------------------------------
add_handler() ->
	sc_event:add_handler(?MODULE, []).

delete_handler() ->
	sc_event:delete_handler(?MODULE, []).


%%----------------------------------------------
%% callback function
%%----------------------------------------------
init([]) ->
	{ok, []}.

handle_call(_Request, State) ->
	{ok, ok, State}.

handle_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

handle_event({create, {Key, Value}}, State) ->
	error_logger:info_msg("create(~w, ~w)~n", [Key, Value]),
	{ok, State};

handle_event({lookup, Key}, State) ->
	error_logger:info_msg("lookup(~w)~n", [Key]),
	{ok, State};

handle_event({delete, Key}, State) ->
	error_logger:info_msg("delete(~w)~n", [Key]),
	{ok, State};

handle_event({replace, {Key, Value}}, State) ->
	error_logger:info_msg("replace(~w, ~w)~n", [Key, Value]),
	{ok, State};

handle_event(_Event, State) ->
	{ok, State}.