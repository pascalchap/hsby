-module(task).

-behaviour(gen_event).

-define(SERVER, ?MODULE).

-include("hsby.hrl").

%% export interfaces
-export([start/1,schedule/1,suspend/1,resume/1,schedule_suspend/1,progress/1,progress_init/1]).

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

progress([Task,_T]) ->
	io:format("~p ... task ~p~n",[Task#task.remain,Task#task.name]),
	Task.

progress_init([Task]) ->
	io:format("... init of task ~p~n",[Task#task.name]),
	Task.


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
	Task = #task{ name=Name, period=Period, manager=Manager, mode=Mode, run=Run, exe=Exe,
	                remain=Remain, priority=Priority, initfunc=Initfunc, runfunc=Runfunc},
	Task1 = lists:foldl(fun({M,F,A},Acc) -> M:F([Acc|A]) end, Task, Initfunc),
	{ok, Task1}.


%% @private
handle_event({tick,V}, #task{name=Name, run=run, mode = exe, remain=Remain, exe=Exe} = Task) ->
	%% io:format("task ~p received tick number ~p~n",[Name,_V]),
	Task1 = lists:foldl(fun({_P,M,F,A},Acc) -> M:F([Acc,V|A]) end, Task,
		lists:filter(fun({P,_M,_F,_A}) -> ((Exe * (100 - P)) div 100) == Remain end,Task#task.runfunc)),
	NewRemain = Remain - 1,
	NewMod = case (NewRemain >= 0) of
		false ->
			plcmanager:task_complete(Name),
			waiting;
		_ -> exe
	end,
	{ok, Task1#task{remain=NewRemain,mode=NewMod}};
handle_event(_Event, Task) ->
	{ok, Task}.

%% @private
handle_call(schedule, #task{run=run, mode = waiting, exe=Exe} = Task) ->
	NewTask = Task#task{mode=exe,remain=Exe},
	{ok,{scheduled,Task#task.name,Exe},NewTask};
handle_call(schedule_suspend, #task{run=run, mode = waiting, exe=Exe} = Task) ->
	NewTask = Task#task{mode=suspend,remain=Exe},
	{ok,{schedule_suspend,Task#task.name,Exe},NewTask};
handle_call(suspend, #task{run=run, mode = exe} = Task) ->
	NewTask = Task#task{mode=suspend},
	{ok,{suspend,Task#task.name,Task#task.remain},NewTask};
handle_call(resume, #task{run=run, mode = suspend} = Task) ->
	NewTask = Task#task{mode=exe},
	{ok,{resume,Task#task.name,Task#task.remain},NewTask};
handle_call(Request, Task) ->
	io:format("task received unexpected request ~p while in state ~n~p~n",[Request,Task]),
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