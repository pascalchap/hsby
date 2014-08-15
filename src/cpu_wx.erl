-module(cpu_wx).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").
-include("hsby_wx.hrl").

-behaviour(wx_object).

-define (SERVER , ?MODULE).

%%
%% Exported Functions
%%
-export([start_link/0,start_link/2]).
%%
%% callback Functions
%%
-export([init/1, handle_info/2, handle_call/3, handle_cast/2, handle_event/2, 
     terminate/2, code_change/3,handle_sync_event/3]).


%%
%% API Functions
%%
start_link() ->
	start_link(800,200).
start_link(W,H) ->
    {wx_ref,_Id,_WxType,Pid} = wx_object:start_link(?MODULE, [W,H], []),
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
   {stop, shutdown, S};
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

terminate(_Reason, _State) ->
    normal.

%%%%%%%%%%%%%%%%%%%%% local functions %%%%%%%%%%%%%

create_window(W,H) ->
   Frame = wxFrame:new(wx:null(), ?MAIN, "PLC",
    							[{size,{W,H}},
                                {style,	?wxMINIMIZE_BOX bor
                                 	?wxSYSTEM_MENU bor
                                 	?wxCAPTION  bor
                                 	?wxCLOSE_BOX
                                 }]),

    IconFile = "priv/m580-2.png",
    Bitmap = wxBitmap:new(IconFile, [{type,?wxBITMAP_TYPE_PNG}]),
    Icon = wxIcon:new(),
    wxIcon:copyFromBitmap(Icon,Bitmap),
    wxFrame:setIcon(Frame, Icon),
    % wxIcon:destroy(Icon),

    wxFrame:setStatusBar(Frame,wxFrame:createStatusBar(Frame,[])),
    wxFrame:connect(Frame, close_window),
    wxWindow:show(Frame),
    {Frame,maps:put(frame,Frame,maps:new())}.
