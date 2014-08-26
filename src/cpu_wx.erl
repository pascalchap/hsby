-module(cpu_wx).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").
-include("hsby_wx.hrl").

-behaviour(wx_object).

-define (SERVER , ?MODULE).

%%
%% Exported Functions
%%
-export([start_link/0,start_link/1,refresh/0]).
%%
%% callback Functions
%%
-export([init/1, handle_info/2, handle_call/3, handle_cast/2, handle_event/2, 
     terminate/2, code_change/3,handle_sync_event/3]).


%%
%% API Functions
%%
start_link() ->
	start_link(800).
start_link(W) ->
    {wx_ref,_Id,_WxType,Pid} = wx_object:start_link(?MODULE, [W,353], []),
    register(?SERVER,Pid),
	?SERVER ! {tick,spawn_link(util,tick,[1000,{?SERVER,refresh,[]}])},
	{ok,Pid}.

refresh() ->
	wx_object:cast(?SERVER,refresh).

init([W,H]) ->
	create_window(W,H).

%%%%%%%%%%%%%%%%%%%%% Server callbacks %%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sync event from callback events, paint event must be handled in callbacks
%% otherwise nothing will be drawn on windows.
handle_sync_event(#wx{event = #wxPaint{},obj = Panel}, _wxObj, State) ->
	% io:format("repaint ~p~n",[Panel]),
	do_refresh(Panel,State),
    ok.

handle_info({tick,Pid},S) ->
	S1 = maps:put(tick,Pid,S), 
    {noreply, S1};
handle_info(_M,S) -> 
    {noreply, S}.

handle_event(#wx{event=#wxClose{}}, S) ->
   {stop, normal, S};
handle_event(#wx{event=#wxCommand{type=command_menu_selected} ,id=I}, S) ->
	S1 = cpu_wx_lib:(list_to_atom(maps:get(I,S)))(S),
	{noreply,S1};
handle_event(#wx{event=E,id=I}, S) ->
    M = io_lib:format("ignore event {~p,~p} ",[maps:get(I,S),E]),
	wxFrame:setStatusText(maps:get(frame,S),M,[]),
    {noreply,S}.

handle_call(What, _From, State) ->
    {stop, {call, What}, State}.

handle_cast(refresh, State) ->
    {noreply, do_draw(State)};
handle_cast(_What, State) ->
    {noreply, State}.
    
code_change(_, _, State) ->
    {stop, not_yet_implemented, State}.

terminate(Reason, State) ->
	maps:get(tick,State) ! stop,
    Reason.

%%%%%%%%%%%%%%%%%%%%% local functions %%%%%%%%%%%%%

create_window(W,H) ->
	WX = wx:new(),
	Xrc = wxXmlResource:get(),
	wxXmlResource:initAllHandlers(Xrc),
	wxXmlResource:load(Xrc,"./priv/cpu.xrc"),
	Frame = wxFrame:new(),
	wxXmlResource:loadFrame(Xrc, Frame,WX,"cpu_frame"),
	wxFrame:connect(Frame, close_window),
	wxFrame:setSize(Frame,{W,H}),
    wxWindow:show(Frame),
    Map = lists:foldl(fun(Name,Acc) -> wx_lib:ld_xrc(Name,Acc)end, maps:new(), cpu_wx_lib:items()),
    wxFrame:connect(Frame,command_menu_selected),
    wxFrame:connect(Frame,command_left_click),
    State = populate(Frame,Map),
    %% io:format("~p~n",[State]),
	wxDC:setBackground(maps:get({"mast",dc},State),maps:get({"mast",bg},State)),
	wxDC:setBrush(maps:get({"mast",dc},State),maps:get({"mast",bg},State)),
	wxDC:setPen(maps:get({"mast",dc},State),maps:get({"mast",pen},State)),
	wxDC:drawRectangle(maps:get({"mast",dc},State), {5,5}, {50,20}),
    {Frame,State}.

populate(Frame,Map) ->
    Elem = maps:put(frame,Frame,Map),
    Elem1 = wx_lib:add_elems(cpu_wx_lib:bitmaps(),wxPanel,Elem),
    Elem2 = wx_lib:add_elems(cpu_wx_lib:info(),wxStaticText,Elem1),
    wx_lib:add_graphic(cpu_wx_lib:bitmaps(),Elem2).


do_refresh(Panel,State) ->
	DC = wxPaintDC:new(Panel),
	Name = wxPanel:getName(Panel),
	% io:format("do_refresh name : ~p, panel : ~p, dictitonnary : ~p~n",[Name,Panel,get()]),
	MemoryDC = maps:get({Name,dc},State),
	Size = wxPanel:getSize(Panel),
	wxDC:blit(DC,{0,0},Size,MemoryDC,{0,0}),
	wxPaintDC:destroy(DC).

do_draw(State) ->
	L = [wx:typeCast(wxWindow:findWindowById(wx_lib:get_id(X)),wxPanel) || {X,_} <- cpu_wx_lib:bitmaps()],
	lists:foldl(fun(X,Acc) -> draw(X,0,Acc) end,State,L).

draw(Panel,_Fun,State) ->
	Name = wxPanel:getName(Panel),
	DC = maps:get({Name,dc},State),
	{W,H} = wxPanel:getSize(Panel),
	NewDC = case wxMemoryDC:getSize(DC) of
		{W,H} -> DC;
		_ ->
			DC1 = wxMemoryDC:new(wxBitmap:new(W,H)),
			wxDC:setBackground(DC1,maps:get({Name,bg},State)),
			wxDC:setBrush(DC1,maps:get({Name,bg},State)),
			wxDC:setPen(DC1,maps:get({Name,pen},State)),
			wxDC:clear(DC1),
			wxDC:drawRectangle(DC1, {5,5}, {50,20}),
			io:format("draw ~p size ~p~n",[Name,{W,H}]),
			DC1
	end,
	wxWindow:refresh(Panel,[{eraseBackground,false}]),
	maps:update({Name,dc},NewDC,State).


