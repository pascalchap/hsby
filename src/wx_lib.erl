-module(wx_lib).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").
-include("hsby_wx.hrl").

-export([ld_xrc/2,get_id/1,add_elems/3,add_graphic/2]).

%%  exported

ld_xrc({Name,_},Map) ->
	ld_xrc(Name,Map);
ld_xrc(Name,Map) when is_atom(Name) ->
	ld_xrc(atom_to_list(Name),Map);
ld_xrc(Name,Map) ->
	Id = wxXmlResource:getXRCID(Name),
	maps:put(Id,Name,Map).

get_id({Name,_}) -> get_id(Name);
get_id(Name) when is_atom(Name) -> get_id(atom_to_list(Name));
get_id(Name) ->
	wxXmlResource:getXRCID(Name).

add_elems([],_Type,Map) -> Map;
add_elems([Name|T],Type,Map) ->
	N = case Name of
		{Nm,_} -> Nm;
		Nm -> Nm
	end,
	add_elems(T,Type,maps:put(N,wx:typeCast(wxWindow:findWindowById(get_id(Name)),Type),Map)).
	
add_graphic([],Map) -> Map;
add_graphic([{Name,FG}|T],Map) ->
	Panel = wx:typeCast(wxWindow:findWindowById(get_id(Name)),wxPanel),
	{W,H} = wxWindow:getSize(Panel),
	BM    = wxBitmap:new(W,H),
	MDC   = wxMemoryDC:new(BM),
	MBG   = wxMemoryDC:getBackground(MDC),
	wxPanel:connect(Panel, paint, [callback]),
	wxPanel:connect(Panel, erase_background, [{callback, fun(_,_) -> ok end}]),
	Pen   = wxPen:new(FG,[{width, 2}]),
	Map1  = maps:put({Name,bm},BM,Map),
	Map2  = maps:put({Name,dc},MDC,Map1),
	Map3  = maps:put({Name,bg},MBG,Map2),
	Map4  = maps:put({Name,pen},Pen,Map3),
	add_graphic(T,Map4).