%%---------------------------------------------
%% @Module	:	gs_tcp_client
%% @Author	:	ycg
%% @Email	:	1050676515@qq.com
%% @Created	:	2014.10.30
%% @Description	:	玩家套接字消息接收进程
%%---------------------------------------------
-module(gs_tcp_client).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0]).

-record(client, {
		pid = none,
		socket = 0,
		ref = 0
}).

-define(HEART_TIMEOUT, 60000).

start_link() ->
	gen_server:start_link(?MODULE, [], []).



init([]) ->
	io:format("start~n"),
	process_flag(trap_exit, true),
	{ok, Pid} = mod_server:start(),
	{ok, #client{pid = Pid}}.

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast({socket, Socket}, State) ->
	{ok, Ref} = async_recv(Socket, 0, ?HEART_TIMEOUT),
	{noreply, State#client{socket = Socket, ref = Ref}};

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info({inet_async, Socket, Ref, {ok, <<Cmd:16, Bin/binary>>}}, #client{socket = Socket, ref = Ref} = State) ->
	case routing(Cmd, Bin) of
		{ok, Data} ->
			case gen_server:call(State#client.pid, {'SOCKET_EVENT', Cmd, Data}) of
				{ok, _} ->
					{noreply, State};
				_Error ->
					{stop, normal, State}
			end;
		_Other ->
			{stop, normal, State}
	end;

%% 超时
handle_info({inet_async, _Socket, _Ref, {error, timeout}}, State) ->
	{stop, normal, State};

%% 套接字关闭
handle_info({'EXIT', _Socket, _Reason}, State) ->
	io:format("close~n"),
	{stop, normal, State};

handle_info(_Info, State) ->
	io:format("~p~n", [_Info]),
	{stop, normal, State}.

terminate(_Reason, #client{pid = Pid, socket = Socket} = _State) ->
	gen_tcp:close(Socket),
	mod_server:stop(Pid),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

async_recv(S, Length, Timeout) ->
	case async_recv(S, Length, Timeout) of
		{ok, Ref} ->
			{ok, Ref};
		Error ->
			Error
	end.

%% 消息路由
routing(Cmd, Binary) ->
	[H1, H2, H3, _, _] = integer_to_list(Cmd),
	Module = list_to_atom("pt_"++[H1, H2, H3]),
	Module:read(Cmd, Binary).