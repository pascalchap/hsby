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
	io:format("......... mast ~p ~n",[Tag]),
	Arg#task{func=Tag}.

send_app_data([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

get_hsby_diag([Arg,T,Tag]) ->
	Diag = diagmanager:get_diag(), 
	io:format("......... mast ~p (time ~p, progress ~p, diag ~p)~n",[Tag,T,Arg#task.remain,Diag#diag.count]),
	Arg#task{diag = Diag, func=Tag}.

hsby_fsm([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

put_hsby_ddt([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

input([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

exe([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

out([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

interscan([Arg,T,Tag]) -> 
	io:format("......... mast ~p (time ~p, progress ~p)~n",[Tag,T,Arg#task.remain]),
	Arg#task{func=Tag}.

