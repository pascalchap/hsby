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
	io:format("......... safe ~p ~n",[Tag]),
	Arg#task{func=Tag}.

send_app_data([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

input([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

exe([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

exchange([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

compare([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

blackchannel([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

out([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

interscan([Arg,T,Tag]) -> 
	io:format("......... safe ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

