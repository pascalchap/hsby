-module(safe).

-include("hsby.hrl").

-export([initfunc/0,runfunc/0]).

-export([init/1,send_app_data/1,input/1,exe/1,exchange/1,compare/1,blackchannel/1,out/1,interscan/1]).

initfunc() ->
	[{safe,init,[init]}].

runfunc() ->
	[
	{0  ,safe,send_app_data,[send_app_data]},
	{10 ,safe,input,[input]},
	{15 ,safe,exe,[exe]},
	{80 ,safe,exchange,[exchange]},
	{87 ,safe,compare,[compare]},
	{95 ,safe,blackchannel,[blackchannel]},
	{96 ,safe,out,[out]},
	{100,safe,interscan,[interscan]}
	].

init([Arg,Tag]) -> 
	util:log({init,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

send_app_data([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

input([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

exe([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

exchange([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

compare([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

blackchannel([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

out([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

interscan([Arg,T,Tag]) -> 
	util:log({T,safe,[Tag,maps:get(remain,Arg)]}),
	maps:put(func,Tag,Arg).

