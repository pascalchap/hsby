-module(hrtbt).

-include("hsby.hrl").

-export([initfunc/0,runfunc/0]).

-export([init/1,create_hrtbt_buf/1,send_buf/1]).

initfunc() ->
	[{hrtbt,init,[init]}].

runfunc() ->
	[
	{0  ,hrtbt,create_hrtbt_buf,[create_hrtbt_buf]},
	{0  ,hrtbt,send_buf,[send_buf]}
	].

init([Arg,Tag]) -> 
	util:log({init,hrtbt,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

create_hrtbt_buf([Arg,T,Tag]) -> 
	util:log({T,hrtbt,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

send_buf([Arg,T,Tag]) -> 
	util:log({T,hrtbt,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

update_hrtbt(Hrtbt,Task) ->
	Task.