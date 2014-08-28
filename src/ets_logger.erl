-module(ets_logger).

-include("hsby.hrl").

-behaviour(gen_event).
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

-export([start/1,stop/1]).

%% interface
start(Node) ->
	pong = net_adm:ping(Node),
	Pid = spawn(fun() -> loop() end),
	io:format("pid logger : ~p~n",[Pid]),
	ok = gen_event:add_handler({?LOGGER,Node}, ?MODULE, Pid).

stop(Node) ->
	ok = gen_event:delete_handler({?LOGGER,Node}, ?MODULE, []).

%% @private
init(Pid) ->
	ets:new(hrtbt,[named_table,ordered_set,public]),
	ets:insert(hrtbt,{0,init}),
	ets:new(fast,[named_table,ordered_set,public]),
	ets:insert(fast,{0,init}),
	ets:new(safe,[named_table,ordered_set,public]),
	ets:insert(safe,{0,init}),
	ets:new(mast,[named_table,ordered_set,public]),
	ets:insert(mast,{0,init}),
	{ok, Pid}.

%% @private
handle_event(Event = {_,scheduler,_}, Pid) ->
	Pid ! Event,
	{ok, Pid};
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
		{T,scheduler,[schedule_suspend,L]} ->
			lists:foreach(fun(X) -> ets:insert(X,{T,schedule_suspend}) end,L),
			loop();
		{T,scheduler,[State,Task]} ->
			ets:insert(Task,{T,State}),
			loop();
		_M ->
			loop()
	end.