%%------------------------------------------------------
%% @Module	:	sc_store
%% @Author	:	ycg
%% @Email	:
%% @Created	:	2014.06.23
%% @Description	:	键值映射操作
%%------------------------------------------------------
-module(sc_store).
-export(
	[
		init/0,
		insert/2,
		delete/1,
		lookup/1
	]
).

-record(key_to_pid, {key, pid}).
-define(TABLE_ID, ?MODULE).

init() ->
%	ets:new(?TABLE_ID, [public, named_table]),
	mnesia:start(),
	mnesia:create_table(key_to_pid, 
						[{index, [pid]},
						 {attributes, record_info(fields, key_to_pid)}]).
	ok.

insert(Key, Pid) ->
%	ets:insert(?TABLE_ID, {Key, Pid}).
	mnesia:dirty_write(#key_to_pid{key = Key, pid = Pid}).

lookup(Key) ->
%	case ets:lookup(?TABLE_ID, Key) of
%		[{Key, Pid}] -> 
%			{ok, Pid};
%		[] -> 
%			{error, not_found}
%	end.
	case mnesia:dirty_read(key_to_pid, Key) of
		[{key_to_pid, Key, Pid}] -> 
			case is_pid_alive(Pid) of
				true ->
					{ok, Pid};
				false ->
					{error, not_found}
			end;
		[] ->
			{error, not_found}
	end.

delete(Pid) ->
	ets:match_delete(?TABLE_ID, {'_', Pid}).


%%------------------------------------------------
%% private function
%%------------------------------------------------
is_pid_alive(Pid) when node(Pid) =:= node() ->
	is_process_alive(Pid);
is_pid_alive(Pid) ->
	lists:member(node(Pid), nodes()) andalso 
	(rpc:call(node(Pid), erlang, is_process_alive, [Pid]) =:= true).