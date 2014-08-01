-module(plcmanager).

-include("hsby.hrl").

-behaviour(gen_server).

-define(SERVER, plcmanager).
-define(GEN_EVENT, plcmanager_event).

-record(state, {time = 0, curtask = none, suspended = []}).

%% export interfaces
-export([start_link/1,stop/1,task_complete/1]).

%% export callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% INTERFACES %%

start_link(Args) ->
	gen_event:start_link({local,?GEN_EVENT}),
	gen_server:start_link({local, ?SERVER}, ?MODULE, Args, []).

stop(Name) ->
	gen_event:stop(Name).

task_complete(Name) ->
	gen_server:cast(?SERVER,{task_complete,Name}).

%% CALLBACK FUNCTIONS %%
%% @private

%%	init(Args) -> Result
%% 
%%	Types:
%%		Args = term()
%%		Result = {ok,State} | {ok,State,Timeout} | {ok,State,hibernate}
%%		| {stop,Reason} | ignore
%%		State = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

init(InitFile) ->
	{ok,Params} = util:get_term(InitFile),
	Tasks = proplists:get_value(tasks,Params),
	[M:F(complete(A)) || {M,F,A} <- Tasks],
	ets:new(task,[named_table,ordered_set]),
	[insert_task(complete(A),0) || {_,_,A} <- Tasks],
	spawn_link(util,tick,[?TICK,tick,self()]),
	{ok, #state{}}.

%%	handle_call(Request, From, State) -> Result
%%		
%%	Types:
%%		Request = term()
%%		From = {pid(),Tag}
%%		State = term()
%%		Result = {reply,Reply,NewState} | {reply,Reply,NewState,Timeout}
%%			| {reply,Reply,NewState,hibernate}
%%			| {noreply,NewState} | {noreply,NewState,Timeout}
%%			| {noreply,NewState,hibernate}
%%			| {stop,Reason,Reply,NewState} | {stop,Reason,NewState}
%%		Reply = term()
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

handle_call(_Request, _From, State) ->
	{reply, {error, unknown_call}, State}.

%%	handle_cast(Request, State) -> Result
%%	
%%	Types:
%%		Request = term()
%%		State = term()
%%		Result = {noreply,NewState} | {noreply,NewState,Timeout}
%%		 	| {noreply,NewState,hibernate}
%%		 	| {stop,Reason,NewState}
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

handle_cast({task_complete,Name}, #state{suspended = Susp} = State) ->
	io:format("ok received task ~p completed~n",[Name]),
	{NewCur,NewSusp} = case Susp of
		[HTask={_Prio,_Per,NewName}|TSusp] -> 
			R = task:resume(NewName),
			io:format("~p --> task resume : ~p~n",[State#state.time, R]),
			{HTask,TSusp};
		[] ->
			{none,[]}
	end,
	{noreply, State#state{suspended=NewSusp,curtask=NewCur}};
handle_cast(_Msg, State) ->
	{noreply, State}.

%%	handle_info(Info, State) -> Result
%%	
%%	Types:
%%		Info = timeout | term()
%%		State = term()
%%		Result = {noreply,NewState} | {noreply,NewState,Timeout}
%%		 	| {noreply,NewState,hibernate}
%%		 	| {stop,Reason,NewState}
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = normal | term()

handle_info(E = {tick,_}, #state{time = T, curtask = CurTask, suspended = Susp} = State) ->
	%% io:format("tick ~p: curtask : ~p, suspended : ~p~n",[T,CurTask,Susp]),
	{NewCurTask,NewSusp} = case ets:lookup(task,T) of
		[{T,List}] -> schedule(List,T,CurTask,Susp);
		[] -> {CurTask,Susp}
	end,
	gen_event:notify(?GEN_EVENT,E),
	{noreply, State#state{time = T+1, curtask = NewCurTask, suspended = NewSusp}};
handle_info(_Info, State) ->
	{noreply, State}.

%%	terminate(Reason, State)
%%	
%%	Types:
%%		Reason = normal | shutdown | {shutdown,term()} | term()
%%		State = term()

terminate(_Reason, _State) ->
	ok.

%%	code_change(OldVsn, State, Extra) -> {ok, NewState} | {error, Reason}
%%
%%	Types:
%%		OldVsn = Vsn | {down, Vsn}
%%		Vsn = term()
%%		State = NewState = term()
%%		Extra = term()
%%		Reason = term()

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% LOCAL FUNCTIONS %%

complete(A) ->
	util:add_default_key(name,task,
		util:add_default_key(period,50000,
			util:add_default_key(exe,15000,
				util:add_default_key(mode,waiting,
					util:add_default_key(run,frozen,
						util:add_default_key(manager,?GEN_EVENT,
							util:add_default_key(initfunc,[],
								util:add_default_key(runfunc,[],
									util:add_default_key(priority,10000,A))))))))).

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
			io:format("~p --> tasks schedule_suspend : ~p~n",[T, R]),
			{CurTask,List};
		CurTask ->
			case CurTask of
				none -> ok;
				{_CurPrio,_CurPer,CurName} ->
					R1 = task:suspend(CurName),
					io:format("~p --> task suspend : ~p~n",[T, R1])
				end,
			R2 = task:schedule(Name),
			io:format("~p --> task schedule : ~p~n",[T, R2]),
			R3 = [task:schedule_suspend(X) || {_Prio,_Per,X} <- Q ],
			io:format("~p --> task schedule_suspend : ~p~n",[T, R3]),
			ets:delete(task,T),
			{Task,[CurTask|Q]}
	end,
	[reschedule_task(Xta,T+Xp) || Xta={_Prio,Xp,_Name} <- List],
	{NewCurtask,merge_suspend(Susp,AddSusp)}.

merge_suspend(L1,L2) ->
	lists:sort([X || X <- L1++L2, X =/= none]).

