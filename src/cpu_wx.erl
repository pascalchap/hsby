-module(cpu_wx).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").
-include("hsby_wx.hrl").

-behaviour(wx_object).

-define (SERVER , ?MODULE).

%%
%% Exported Functions
%%
-export([start_link/0,start_link/1]).
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
	{ok,Pid}.


init([W,H]) ->
	wx:new(),
	wx:batch(fun() -> create_window(W,H) end).


%%%%%%%%%%%%%%%%%%%%% Server callbacks %%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sync event from callback events, paint event must be handled in callbacks
%% otherwise nothing will be drawn on windows.
handle_sync_event(#wx{event = #wxPaint{}}, _wxObj, _State) ->
    ok.

handle_info(_M,S) -> 
    {noreply, S}.

handle_event(#wx{id=?MAIN,event=#wxClose{}}, S) ->
   {stop, normal, S};
handle_event(E, S) ->
    M = io_lib:format("ignore event ~p ",[E#wx.event]),
   wxFrame:setStatusText(maps:get(frame,S),M,[]),
    {noreply,S}.

handle_call(What, _From, State) ->
    {stop, {call, What}, State}.

handle_cast(_What, State) ->
    {noreply, State}.
    
code_change(_, _, State) ->
    {stop, not_yet_implemented, State}.

terminate(Reason, _State) ->
    Reason.

%%%%%%%%%%%%%%%%%%%%% local functions %%%%%%%%%%%%%

create_window(W,H) ->
   Frame = wxFrame:new(wx:null(), ?MAIN, "PLC",
    							[{size,{W,H}},
                                {style,	?wxMINIMIZE_BOX bor
                                 	?wxSYSTEM_MENU bor
                                 	?wxCAPTION  bor
                                 	?wxCLOSE_BOX
                                 }]),

    %% Menus et status et icon bar
    wx_lib:add_menu_bar(Frame,[file_menu(),aff_menu(),help_menu()]),

    wxFrame:setStatusBar(Frame,wxFrame:createStatusBar(Frame,[])),

    wx_lib:add_tool_bar(Frame,toolbar()),

    % ICON
    % IconFile = "priv/m580-2.png",
    % Bitmap = wxBitmap:new(IconFile, [{type,?wxBITMAP_TYPE_PNG}]),
    % Icon = wxIcon:new(),
    % wxIcon:copyFromBitmap(Icon,Bitmap),
    % wxFrame:setIcon(Frame, Icon),
    % wxIcon:destroy(Icon),

    %% sizers
    %% sizes decoration -> 12
    %% border: 8, Title: 35, Menu: 26, Toolbar: IconH + 9, Status: 29
    MainSz = wxBoxSizer:new(?wxHORIZONTAL),
    wxFrame:setSizer(Frame,MainSz),
    io:format("taille MainSz: ~p~n",[wxBoxSizer:getSize(MainSz)]),
    Disp = wxPanel:new(Frame, [{size,{210,210}}]),
    wxBoxSizer:add(MainSz,Disp),
    wxBoxSizer:addSpacer(MainSz,4),
    W2 = W-210 - 6 - 4,
    Plot = wxPanel:new(Frame, [{size,{W2,210}}]),
    PlotSz = wxBoxSizer:new(?wxVERTICAL),
    % wxBoxSizer:add(MainSz,Plot,[{flag, ?wxGROW bor ?wxALIGN_CENTER}]),
    wxBoxSizer:add(MainSz,Plot),
    wxPanel:setSizer(Plot,PlotSz),
    Hrtbt = wxPanel:new(Plot,[]),
    Fast = wxPanel:new(Plot,[]),
    Safe = wxPanel:new(Plot,[]),
    Mast = wxPanel:new(Plot,[]),
    wxBoxSizer:add(PlotSz,Hrtbt),
    wxBoxSizer:addSpacer(PlotSz,4),
    wxBoxSizer:add(PlotSz,Fast),
    wxBoxSizer:addSpacer(PlotSz,4),
    wxBoxSizer:add(PlotSz,Safe),
    wxBoxSizer:addSpacer(PlotSz,4),
    wxBoxSizer:add(PlotSz,Mast),
    HrtbtSz = wxBoxSizer:new(?wxHORIZONTAL),
    wxPanel:setSizer(Hrtbt,HrtbtSz),
    wxBoxSizer:add(HrtbtSz,wxStaticText:new(Hrtbt,-1,"Hrtbt:",[{style,?wxALIGN_RIGHT}]),[{flag,?wxALIGN_CENTRE_VERTICAL bor ?wxALL},{proportion,60},{border, 3}]),
    wxBoxSizer:addSpacer(HrtbtSz,4),
    wxBoxSizer:add(HrtbtSz,wxPanel:new(Hrtbt,[{size,{-1,44}}]),[{proportion,W2 - 60},{flag, ?wxEXPAND bor ?wxALL},{border, 3}]),
    FastSz  = wxBoxSizer:new(?wxHORIZONTAL),
    wxPanel:setSizer(Fast,FastSz),
    wxBoxSizer:add(FastSz,wxStaticText:new(Fast,-1,"Fast :",[{style,?wxALIGN_RIGHT}]),[{flag,?wxALIGN_CENTRE_VERTICAL bor ?wxALL},{proportion,60},{border, 3}]),
    wxBoxSizer:addSpacer(FastSz,4),
    wxBoxSizer:add(FastSz,wxPanel:new(Fast,[{size,{-1,44}}]),[{proportion,W2 - 60},{flag, ?wxEXPAND bor ?wxALL},{border, 3}]),
    SafeSz  = wxBoxSizer:new(?wxHORIZONTAL),
    wxPanel:setSizer(Safe,SafeSz),
    wxBoxSizer:add(SafeSz,wxStaticText:new(Safe,-1,"Safe :",[{style,?wxALIGN_RIGHT}]),[{flag,?wxALIGN_CENTRE_VERTICAL bor ?wxALL},{proportion,60},{border, 3}]),
    wxBoxSizer:addSpacer(SafeSz,4),
    wxBoxSizer:add(SafeSz,wxPanel:new(Safe,[{size,{-1,44}}]),[{proportion,W2 - 60},{flag, ?wxEXPAND bor ?wxALL},{border, 3}]),
    MastSz  = wxBoxSizer:new(?wxHORIZONTAL),
    wxPanel:setSizer(Mast,MastSz),
    wxBoxSizer:add(MastSz,wxStaticText:new(Mast,-1,"Mast :",[{style,?wxALIGN_RIGHT}]),[{flag,?wxALIGN_CENTRE_VERTICAL bor ?wxALL},{proportion,60},{border, 3}]),
    wxBoxSizer:addSpacer(MastSz,4),
    wxBoxSizer:add(MastSz,wxPanel:new(Mast,[{size,{-1,44}}]),[{proportion,W2 - 60},{flag, ?wxEXPAND bor ?wxALL},{border, 3}]),


    %% Zone de controle

    %% Zone graphique

    %% connect event
    wxFrame:connect(Frame, close_window),

    wxWindow:show(Frame),
    {Frame,maps:put(frame,Frame,maps:new())}.



file_menu() ->
	{"&File",[{normal,?QUIT, "&Quit the marvelous calculette"}]}.
help_menu() ->
	{"&Help",[{normal,?ABOUT, "About"}]}.
aff_menu() ->
	{"&Affichage",[
		{radio,?BIN, "Binaire",no},
		{radio,?OCT, "Octal",no},
		{radio,?DEC, "Decimal",check},
		{radio,?HEX, "Hexadecimal",no},
		separator,
		{normal,?CLEARDISP, "Clear display"},
		separator,
		{check,?ERR, "Show errors",check}
	]}.


toolbar() ->
	[{normal,100,{"priv/m580-2.png",?wxBITMAP_TYPE_PNG}},
	{normal,101,{"priv/m580-2.png",?wxBITMAP_TYPE_PNG}},
	separator,
	separator,
	{check,102,"test",{"priv/m580-2.png",?wxBITMAP_TYPE_PNG}},
	separator,
	{radio,103,"test1",{"priv/m580-2.png",?wxBITMAP_TYPE_PNG}},
	{radio,104,"test2",{"priv/m580.png",?wxBITMAP_TYPE_PNG}},
	{radio,105,"test3",{"priv/m580-2.png",?wxBITMAP_TYPE_PNG}}
	].