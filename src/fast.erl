-module(fast).

-include("hsby.hrl").

-export([initfunc/0,runfunc/0]).

-export([init/1,send_app_data/1,input/1,exe/1,out/1,interscan/1]).

initfunc() ->
	[{fast,init,[init]}].

runfunc() ->
	[
	{0  ,fast,send_app_data,[send_app_data]},
	{10 ,fast,input,[input]},
	{15 ,fast,exe,[exe]},
	{90 ,fast,out,[out]},
	{100,fast,interscan,[interscan]}
	].

init([Arg,Tag]) -> 
	util:log({init,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

send_app_data([Arg,T,Tag]) -> 
	util:log({T,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

input([Arg,T,Tag]) -> 
	util:log({T,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

exe([Arg,T,Tag]) -> 
	util:log({T,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

out([Arg,T,Tag]) -> 
	util:log({T,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

interscan([Arg,T,Tag]) -> 
	util:log({T,fast,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

