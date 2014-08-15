-module(mast).

-include("hsby.hrl").

-export([initfunc/0,runfunc/0]).

-export([init/1,send_app_data/1,get_hsby_diag/1,hsby_fsm/1,put_hsby_ddt/1,input/1,exe/1,out/1,interscan/1]).

initfunc() ->
	[{mast,init,[init]}].

runfunc() ->
	[
	{0  ,mast,send_app_data,[send_app_data]},
	{10 ,mast,get_hsby_diag,[get_hsby_diag]},
	{10 ,mast,hsby_fsm,[hsby_fsm]},
	{10 ,mast,put_hsby_ddt,[put_hsby_ddt]},
	{10 ,mast,input,[input]},
	{20 ,mast,exe,[exe]},
	{90 ,mast,out,[out]},
	{100,mast,interscan,[interscan]}
	].

init([Arg,Tag]) -> 
	util:log({init,mast,[Tag,maps:get(remain,Arg)]}),
	util:update([{hsbyddt,?HSBYDDT},{func,Tag}],Arg).

send_app_data([Arg,T,Tag]) -> 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

get_hsby_diag([Arg,T,Tag]) ->
	Diag = diagmanager:get_diag(), 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	util:update([{diag,Diag},{func,Tag}],Arg).

hsby_fsm([Arg,T,Tag]) ->
	Hsby_state = hsby_fsm:get_new_hsby_state(maps:get(hsbyddt,Arg)),
	Hsbyddt = evalddt(Hsby_state,Arg),
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	util:update([{func,Tag},{hsbyddt,Hsbyddt}],Arg).

put_hsby_ddt([Arg,T,Tag]) ->
	plcmanager:update_hrtbt_info(maps:get(hsbyddt,Arg)),
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

input([Arg,T,Tag]) -> 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

exe([Arg,T,Tag]) -> 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

out([Arg,T,Tag]) -> 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

interscan([Arg,T,Tag]) -> 
	util:log({T,mast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).


%% Private functions

evalddt(Hsby_state,_Arg) -> Hsby_state.