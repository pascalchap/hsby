-module(text_logger).

-include("hsby.hrl").

-behaviour(gen_event).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

-export([start/1,start/2,stop/1]).

%% interface
start(Node) ->
	start(Node,all).

start(Node,F) ->
	pong = net_adm:ping(Node),
	Pid = spawn(fun() -> loop() end),
	ok = gen_event:add_handler({?LOGGER,Node}, ?MODULE, {Pid,F}).

stop(Node) ->
	ok = gen_event:delete_handler({?LOGGER,Node}, ?MODULE, []).

%% @private
init(Arg) ->
	{ok, Arg}.

%% @private
handle_event(Event, S = {Pid,all}) ->
	Pid ! Event,
	{ok, S};
handle_event(Event = {_,State,_}, S = {Pid,State}) ->
	Pid ! Event,
	{ok, S};
handle_event(_Event, State) ->
	{ok, State}.

%% @private
handle_call(_Request, _State) ->
	{remove_handler, {error, unknown_call}}.

%% @private
handle_info(_Info, State) ->
	{ok, State}.

%% @private
terminate(_Reason, {Pid,_F}) ->
	Pid ! stop,
	ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

loop() ->
	receive
		stop -> ok;
		E ->
			io:format("~p~n",[E]),
			loop()
	end.