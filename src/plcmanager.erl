-module(plcmanager).

-include("hsby.hrl").

-behaviour(gen_fsm).

-define(SERVER, ?MODULE).

-define(STATE, #{time => 0, curtask => none, suspended => [], tick => undefined, plc => maps:new()}).

%% export interfaces
-export([start_link/1,stop/1,task_complete/1,update_hrtbt_info/1,get_plc_state/0,tick/1,get_time/0]).

%% export callbacks
-export([init/1, handle_info/3, terminate/3, code_change/4, handle_event/3, handle_sync_event/4]).

%% export states
-export([noconf/2, noconf/3]).

%% INTERFACES %%

start_link(InitFile) ->
	gen_event:start_link({local,?GEN_EVENT}),
	gen_event:start_link({local,?LOGGER}),
	gen_fsm:start_link({local, ?SERVER}, ?MODULE, InitFile, []).

stop(Name) ->
	gen_fsm:stop(Name).

task_complete(Name) ->
	gen_fsm:send_event(?SERVER,{task_complete,Name}).

update_hrtbt_info(Hrtbt) ->
	gen_event:notify(?GEN_EVENT,{update_hrtbt_info,Hrtbt}).

get_plc_state() ->
	gen_fsm:sync_send_all_state_event(?SERVER, get_plc_state).

tick(T) ->
	gen_fsm:send_event(?SERVER,{tick,T}).

get_time() ->
	gen_fsm:sync_send_all_state_event(?SERVER, get_time).

%% CALLBACK FUNCTIONS %%
%% @private
%%	init(Args) -> Result
%%
%%	Types:
%%		Args = term()
%%		Result = {ok,StateName,StateData} | {ok,StateName,StateData,Timeout}
%%			| {ok,StateName,StateData,hibernate}
%%			| {stop,Reason} | ignore
%%		StateName = atom()
%%		StateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

init(InitFile) ->
	{ok,Params} = util:get_term(InitFile),
	init_tasks(proplists:get_value(tasks,Params)),
	Plc = init_plc(proplists:get_value(plc,Params)),
	Tick = proplists:get_value(tick,Params,?TICK),
	spawn_link(util,tick,[Tick,{?MODULE,tick,[],fun([],V) -> [V] end}]),
	{ok, noconf, util:update([{plc,Plc},{tick,Tick}],?STATE)}.

%% @private
%%	StateName(Event, StateData) -> Result
%%	
%%	Types:
%%		Event = timeout | term()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

noconf({tick,_V},State) ->
	{NewCurTask,NewSusp} = tick(T=maps:get(time,State),maps:get(curtask,State),maps:get(suspended,State)),
	{next_state, 
		noconf, 
		util:update([{time,T+1},{curtask,NewCurTask},{suspended,NewSusp}],State),
		2 * maps:get(tick,State)};
noconf({task_complete,Name},State) ->
	util:log({T = maps:get(time,State),scheduler,[completed,Name]}),
	{NewCur,NewSusp} = case maps:get(suspended,State) of
		[HTask={_Prio,_Per,NewName}|TSusp] -> 
			R = task:resume(NewName),
			util:log({T,scheduler,[resume,R]}),
			{HTask,TSusp};
		[] ->
			{none,[]}
	end,
	{next_state, noconf, util:update([{suspended,NewSusp},{curtask,NewCur}],State)};
noconf(_Event, State) ->
	{next_state, noconf, State}.

%% @private
%%	StateName(Event, From, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		From = {pid(),Tag}
%%		StateData = term()
%%		Result = {reply,Reply,NextStateName,NewStateData}
%%			| {reply,Reply,NextStateName,NewStateData,Timeout}
%%			| {reply,Reply,NextStateName,NewStateData,hibernate}
%%			| {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,Reply,NewStateData} | {stop,Reason,NewStateData}
%%		Reply = term()
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = normal | term()
 
 noconf(_Event, _From, State) ->
	{reply, ok, noconf, State}.

%% @private
%%	handle_event(Event, StateName, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		StateName = atom()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

handle_event(_Event, StateName, State) ->
	{next_state, StateName, State}.

%% @private
%%	handle_sync_event(Event, From, StateName, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		From = {pid(),Tag}
%%		StateName = atom()
%%		StateData = term()
%%		Result = {reply,Reply,NextStateName,NewStateData}
%%			| {reply,Reply,NextStateName,NewStateData,Timeout}
%%			| {reply,Reply,NextStateName,NewStateData,hibernate}
%%			| {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,Reply,NewStateData} | {stop,Reason,NewStateData}
%%		Reply = term()
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

handle_sync_event(get_plc_state, _From, StateName, State) ->
	{reply, State, StateName, State};
handle_sync_event(get_time, _From, StateName, State) ->
	{reply, maps:get(time,State), StateName, State};
handle_sync_event(_Event, _From, StateName, State) ->
	{reply, ok, StateName, State}.

%% @private
%%	handle_info(Info, StateName, StateData) -> Result
%%
%%	Types:
%%		Info = term()
%%		StateName = atom()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = normal | term()

handle_info(_Info, StateName, State) ->
	{next_state, StateName, State}.

%% @private
%%	terminate(Reason, StateName, StateData)
%%
%%	Types:
%%		Reason = normal | shutdown | {shutdown,term()} | term()
%%		StateName = atom()
%%		StateData = term()

terminate(_Reason, _StateName, _State) ->
	ok.

%% @private
%%	code_change(OldVsn, StateName, StateData, Extra) -> {ok, NextStateName, NewStateData}
%%
%%	Types:
%%		OldVsn = Vsn | {down, Vsn}
%%		Vsn = term()
%%		StateName = NextStateName = atom()
%%		StateData = NewStateData = term()
%%		Extra = term()

code_change(_OldVsn, StateName, State, _Extra) ->
	{ok, StateName, State}.

%% LOCAL FUNCTIONS %%

complete(A) ->
	util:complete(A,[{name,task},{period,50000},{exe,15000},{mode,waiting},{run,frozen},
					{manager,?GEN_EVENT},{initfunc,[]},{runfunc,[]},{priority,10000}]).

insert_task(A,T) ->
	case proplists:get_value(run,A) of
		run -> 
			Task = {proplists:get_value(priority,A),proplists:get_value(period,A),proplists:get_value(name,A)},
			PendingList = getpending(T),
			ets:insert(task,{T,lists:sort([Task|PendingList])});
		_ ->
			nothing
		end.

getpending(T) ->
	case ets:next(task,T-1) of
		T -> [{T,List}] = ets:lookup(task,T),
		     List;
		_ -> [] 
	end.

reschedule_task(Task,T) ->
	%% {T,Task = {_Prio,Per,Name}} = getstart(Name,ets:first(task)),
	%% remove_task(T,Task),
	PendingList = getpending(T),
	ets:insert(task,{T,lists:sort([Task|PendingList])}).

schedule(List = [Task = {Prio,_Period,Name}|Q],T,CurTask,Susp) ->
	{NewCurtask,AddSusp} = case CurTask of
		{CurPrio,_CurPer,_CurName} when CurPrio =< Prio ->
			R = [task:schedule_suspend(X) || {_Prio,_Per,X} <- List ],
			util:log({T,scheduler,[schedule_suspend,R]}),
			{CurTask,List};
		CurTask ->
			case CurTask of
				none -> ok;
				{_CurPrio,_CurPer,CurName} ->
					R1 = task:suspend(CurName),
					util:log({T,scheduler,[suspend,R1]})
				end,
			R2 = task:schedule(Name),
			util:log({T,scheduler,[schedule,R2]}),
			R3 = [task:schedule_suspend(X) || {_Prio,_Per,X} <- Q ],
			util:log({T,scheduler,[schedule_suspend,R3]}),
			ets:delete(task,T),
			{Task,[CurTask|Q]}
	end,
	[reschedule_task(Xta,T+Xp) || Xta={_Prio,Xp,_Name} <- List],
	{NewCurtask,merge_suspend(Susp,AddSusp)}.

merge_suspend(L1,L2) ->
	lists:sort([X || X <- L1++L2, X =/= none]).

init_tasks(Tasks) ->
	[M:F(complete(A)) || {M,F,A} <- Tasks],
	ets:new(task,[named_table,ordered_set]),
	[insert_task(complete(A),0) || {_,_,A} <- Tasks].

init_plc(Props) ->
	M = util:update(Props,?PLC),
	io:format("Plc : ~p~n",[M]),
	M.
tick(T,CurTask,Suspended) ->
	{NewCurTask,NewSusp} = case ets:lookup(task,T) of
		[{T,List}] -> schedule(List,T,CurTask,Suspended);
		[] -> {CurTask,Suspended}
	end,
	gen_event:notify(?GEN_EVENT,{tick,T}),
	{NewCurTask,NewSusp}.
