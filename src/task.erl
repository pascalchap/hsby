-module(task).

-behaviour(gen_event).

-define(SERVER, ?MODULE).

-include("hsby.hrl").

%% export interfaces
-export([start/1,schedule/1,suspend/1,resume/1,schedule_suspend/1]).

%% export callbacks
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

%% INTERFACES %%

start(Args) ->
	Name = proplists:get_value(name,Args,task),
	Manager = proplists:get_value(manager,Args,plcmanager_event),
	ok = gen_event:add_handler(Manager,{?SERVER,Name},Args).

schedule(Name) ->
	gen_event:call(plcmanager_event,{?MODULE,Name},schedule).

suspend(Name) ->
	gen_event:call(plcmanager_event,{?MODULE,Name},suspend).

resume(Name) ->
	gen_event:call(plcmanager_event,{?MODULE,Name},resume).

schedule_suspend(Name) ->
	gen_event:call(plcmanager_event,{?MODULE,Name},schedule_suspend).


%% CALLBACK FUNCTIONS %%
%% @private

init(Args) ->
	Name = proplists:get_value(name,Args),
	Period = proplists:get_value(period,Args),
	Exe = proplists:get_value(exe,Args),
	Remain = 0,
	Mode = proplists:get_value(mode,Args),
	Run = proplists:get_value(run,Args),
	Manager = proplists:get_value(manager,Args),
	Priority = proplists:get_value(priority,Args),
	Initfunc = get_func(proplists:get_value(initfunc,Args)),
	Runfunc = get_func(proplists:get_value(runfunc,Args)),
	Task = util:update([{name,Name}, {period,Period}, {manager,Manager}, {mode,Mode}, {run,Run}, {exe,Exe},
		                {remain,Remain}, {priority,Priority}, {initfunc,Initfunc}, {runfunc,Runfunc}],maps:new()),
	Task1 = lists:foldl(fun({M,F,A},Acc) -> M:F([Acc|A]) end, Task, Initfunc),
	{ok, Task1}.


%% @private
handle_event({tick,V}, Task) ->
	case task_in(Task,[{run,run},{mode,exe}]) of
		true ->
			Remain = maps:get(remain,Task),
			Task1 = lists:foldl(fun({_P,M,F,A},Acc) -> M:F([Acc,V|A]) end, Task,
				lists:filter(fun({P,_M,_F,_A}) -> ((maps:get(exe,Task) * (100 - P)) div 100) == Remain end,maps:get(runfunc,Task))),
			NewRemain = Remain - 1,
			NewMod = case (NewRemain >= 0) of
				false ->
					plcmanager:task_complete(maps:get(name,Task)),
					waiting;
				_ -> exe
			end,
			{ok, util:update([{remain,NewRemain},{mode,NewMod}],Task1)};
		_ -> {ok, Task}
	end;
handle_event({update_hrtbt,Hrtbt}, Task) ->
	New_task = case task_in(Task,[{name,hrtbt}]) of
		true ->
			%% io:format("----->>>>> updating hrtbt frame to send~n"),
			hrtbt:update_hrtbt(Hrtbt,Task);
		_ -> Task
	end,
	{ok, New_task};
handle_event(_Event, Task) ->
	{ok, Task}.

%% @private
handle_call(schedule, Task) ->
	true = task_in(Task,[{run,run},{mode,waiting}]),
	Exe = maps:get(exe,Task),
	{ok,{scheduled,maps:get(name,Task),Exe},util:update([{mode,exe},{remain,Exe}],Task)};
handle_call(schedule_suspend, Task) ->
	true = task_in(Task,[{run,run},{mode,waiting}]),
	Exe = maps:get(exe,Task),
	{ok,{schedule_suspend,maps:get(name,Task),Exe},util:update([{mode,suspend},{remain,Exe}],Task)};
handle_call(suspend, Task) ->
	true = task_in(Task,[{run,run},{mode,exe}]),
	{ok,{suspend,maps:get(name,Task),maps:get(remain,Task)},util:update({mode,suspend},Task)};
handle_call(resume, Task) ->
	true = task_in(Task,[{run,run},{mode,suspend}]),
	{ok,{resume,maps:get(name,Task),maps:get(remain,Task)},util:update({mode,exe},Task)};
handle_call(_Request, Task) ->
	%% io:format("task received unexpected request ~p while in state ~n~p~n",[_Request,Task]),
	{ok, reply, Task}.

%% @private
handle_info(_Info, Task) ->
	{ok, Task}.

%% @private
terminate(_Reason, _Task) ->
	ok.

%% @private
code_change(_OldVsn, Task, _Extra) ->
	{ok, Task}.

%% LOCAL FUNCTIONS

get_func(A) when is_list(A) -> A;
get_func({M,F}) -> M:F(). 

task_in(_T,[]) -> true;
task_in(T,[{K,V}|Q]) ->
	case maps:get(K,T) of
		V -> task_in(T,Q);
		_ -> false
	end.