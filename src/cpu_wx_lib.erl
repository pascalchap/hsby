-module(cpu_wx_lib).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").

-export([items/0,info/0,bitmaps/0,
	plc_sum/1,zoomin/1,zoomout/1,zoomfit/1,toend/1,tostart/1,loadconfig/1,storeconfig/1,
	selectlog/1,startlog/1,contlog/1,stoplog/1,clrlog/1,loghrtbt/1,logfast/1,logsafe/1,logmast/1,
	logstates/1
	]).


items() ->
	info() ++ bitmaps() ++
	[cpu_frame,
	%% commands
	plc_sum, zoomin, zoomout, zoomfit, toend, tostart, loadconfig, storeconfig, selectlog, startlog,
	contlog, stoplog, clrlog, loghrtbt, logfast, logsafe, logmast, logstates
	].

info() ->
	[%% info
	run_stop,
	hsby,
	power].

bitmaps() ->
	[%% bitmaps
	{"time_scale",{255,255,255}},
	{"hrtbt",{0,0,127}},
	{"fast",{0,127,0}},
	{"safe",{0,127,127}},
	{"mast",{40,40,40}}].

plc_sum(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : plc_sum",[]),
	S.
zoomin(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : zoomin",[]),
	S.
zoomout(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : zoomout",[]),
	S.
zoomfit(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : zoomfit",[]),
	S.
toend(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : toend",[]),
	S.
tostart(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : tostart",[]),
	S.
loadconfig(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : loadconfig",[]),
	S.
storeconfig(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : storeconfig",[]),
	S.
selectlog(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : selectlog",[]),
	S.
startlog(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : startlog",[]),
	S.
contlog(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : contlog",[]),
	S.
stoplog(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : stoplog",[]),
	S.
clrlog(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : clrlog",[]),
	S.
loghrtbt(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : loghrtbt",[]),
	S.
logfast(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : logfast",[]),
	S.
logsafe(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : losafe",[]),
	S.
logmast(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : logmast",[]),
	S.
logstates(S) -> 
	wxFrame:setStatusText(maps:get(frame,S),"To do : logstates",[]),
	S.

