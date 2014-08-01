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
	io:format("......... hrtbt ~p ~n",[Tag]),
	Arg#task{func=Tag}.

create_hrtbt_buf([Arg,T,Tag]) -> 
	io:format("......... hrtbt ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

send_buf([Arg,T,Tag]) -> 
	io:format("......... hrtbt ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

