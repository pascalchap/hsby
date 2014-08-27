-module(cpu_wx_lib).

-include_lib("wx/include/wx.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("hsby.hrl").

-export([items/0,info/0,bitmaps/0,
	plc_sum/1,zoomin/1,zoomout/1,zoomfit/1,toend/1,tostart/1,loadconfig/1,storeconfig/1,
	selectlog/1,startlog/1,contlog/1,stoplog/1,clrlog/1,loghrtbt/1,logfast/1,logsafe/1,logmast/1,
	logstates/1,
	draw_state/5,draw_time/5,pos/4
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
	{"time_scale",{255,255,255},{?MODULE,draw_time}},
	{"hrtbt",{0,0,492},{?MODULE,draw_state}},
	{"fast",{0,192,0},{?MODULE,draw_state}},
	{"safe",{255,40,40},{?MODULE,draw_state}},
	{"mast",{40,40,40},{?MODULE,draw_state}}].

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

draw_time(_Name,DC,W,H,State) ->
	wxMemoryDC:clear(DC),
	{Tmin,T} = maps:get(bound,State),
	Tmax = max(T,Tmin + 10),
	wxMemoryDC:drawLabel(DC,integer_to_list(Tmin),{3,0,30,10}),
	wxMemoryDC:drawLabel(DC,integer_to_list(Tmax),{W-60,0,57,10},[{alignment, ?wxALIGN_RIGHT}]),
	wxMemoryDC:drawLine(DC,{2,H-2},{W-2,H-2}),
	lists:foreach(fun(X) -> Wx = ((W-4)*X) div 10,
	                         wxMemoryDC:drawLine(DC,{Wx,H-6},{Wx,H-2}) end,
	                         [1,2,3,4,5,6,7,8,9]).

draw_state(Name,DC,W,H,State) ->
	wxDC:clear(DC),
	Hl = H - 4,
	Hm = H div 2,
	Hh = 4,
	Na = list_to_existing_atom(Name),
	{Tmin,T} = maps:get(bound,State),
	Tmax = max(T,Tmin + 10),
	MS = ets:fun2ms(fun({Tx,Sx}) when Tx >= Tmin, Tx =< Tmax -> {Tx,Sx} end),
	%% Aff = cleanup([{Tx,Sx} || {Tx,scheduler,[Sx,Nx]} <- log:get(), Na == Nx, Tx >= Tmin, Tx =< Tmax],[]),
	[{Ts,Ss}|Q] = ets:select(Na,MS),
	plot(DC,W,Tmin,Tmax,Tmax-Tmin,Hl,Hm,Hh,Ts,pos(Ss,Hl,Hm,Hh),Q).

plot(DC,W,Tmin,_Tmax,Delta,_Hl,_Hm,_Hh,LastT,LastPos,[]) ->
	Xs = 2 + ((LastT-Tmin) * (W-4)) div Delta,
	Xe = W-2,
	wxMemoryDC:drawLine(DC,{Xs,LastPos},{Xe,LastPos});	
plot(DC,W,Tmin,Tmax,Delta,Hl,Hm,Hh,LastT,LastPos,[{Tc,Sc}|Q]) ->
	Xs = 2 + ((LastT-Tmin) * (W-4)) div Delta,
	Xe = 2 + ((Tc-Tmin) * (W-4)) div Delta,
	NewPos = pos(Sc,Hl,Hm,Hh),
	wxMemoryDC:drawLine(DC,{Xs,LastPos},{Xe,LastPos}),
	wxMemoryDC:drawLine(DC,{Xe,LastPos},{Xe,NewPos}),
	plot(DC,W,Tmin,Tmax,Delta,Hl,Hm,Hh,Tc,NewPos,Q).

pos(schedule,_Hl,_Hm,Hh) -> Hh;
pos(resume,_Hl,_Hm,Hh) -> Hh;
pos(completed,Hl,_Hm,_Hh) -> Hl;
pos(init,Hl,_Hm,_Hh) -> Hl;
pos(suspend,_Hl,Hm,_Hh) -> Hm;
pos(schedule_suspend,_Hl,Hm,_Hh) -> Hm.

cleanup([H],R) -> lists:reverse([H|R]);
cleanup([{T,_S},{T,S}|Q],R) -> cleanup([{T,S}|Q],R);
cleanup([H|Q],R) -> cleanup(Q,[H|R]).