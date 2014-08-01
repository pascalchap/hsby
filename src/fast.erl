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
	io:format("......... fast ~p ~n",[Tag]),
	Arg#task{func=Tag}.

send_app_data([Arg,T,Tag]) -> 
	io:format("......... fast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

input([Arg,T,Tag]) -> 
	io:format("......... fast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

exe([Arg,T,Tag]) -> 
	io:format("......... fast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

out([Arg,T,Tag]) -> 
	io:format("......... fast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

interscan([Arg,T,Tag]) -> 
	io:format("......... fast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

