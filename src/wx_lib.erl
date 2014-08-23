-module(wx_lib).

-include_lib("wx/include/wx.hrl").
-include("hsby.hrl").
-include("hsby_wx.hrl").

-export([add_menu_bar/2,add_tool_bar/2,add_tool_bar/3]).

%%  exported

add_menu_bar(Frame,Menus) ->
    MenuBar = wxMenuBar:new(),
    [add_menu(MenuBar,Menu) || Menu <- Menus],
    wxFrame:setMenuBar(Frame, MenuBar),
    wxFrame:connect(Frame, command_menu_selected).


add_tool_bar(Frame,Tools) -> add_tool_bar(Frame,Tools,{48,48}).

add_tool_bar(Frame,Tools,Size) ->
	TB = wxFrame:createToolBar(Frame),
	%%wxToolBar:setToolSeparation(TB,10),
    wxToolBar:setToolBitmapSize(TB,Size),
    [addtool(TB,Tool) || Tool <- Tools ],
    wxToolBar:realize(TB),
    wxFrame:setToolBar(Frame,TB).


%% local
%% menu
add_menu(MB,{Title,Items}) ->
	M = wxMenu:new([]),
	[add_items(M,I) || I <- Items],
    wxMenuBar:append(MB, M, Title).

add_items(M,{radio,ID,Str,Checked}) ->
    It = wxMenu:appendRadioItem(M, ID, Str),
    case Checked of
    	check -> wxMenuItem:check(It);
    	_ -> ok
    end;

add_items(M,{check,ID,Str,Checked}) ->
    It = wxMenu:appendCheckItem(M, ID, Str),
    case Checked of
    	check -> wxMenuItem:check(It);
    	_ -> ok
    end;
add_items(M,separator) ->
    wxMenu:appendSeparator(M);
add_items(M,{normal,ID,Str}) ->
    wxMenu:append(M, ID, Str).

%% toolbar

addtool(TB,{normal,ID,{File,Type}}) ->
	Bitmap = wxBitmap:new(File, [{type,Type}]),
    wxToolBar:addTool(TB,ID,Bitmap),
    %% wxBitmap:destroy(Bitmap);
    ok;
addtool(TB,separator) ->
	wxToolBar:addSeparator(TB);
addtool(TB,{check,ID,Label,{FileEn,TypeEn}}) ->
	BitmapEn = wxBitmap:new(FileEn, [{type,TypeEn}]),
    wxToolBar:addCheckTool(TB,ID,Label,BitmapEn),
    wxBitmap:destroy(BitmapEn);
addtool(TB,{radio,ID,Label,{FileEn,TypeEn}}) ->
	BitmapEn = wxBitmap:new(FileEn, [{type,TypeEn}]),
    wxToolBar:addRadioTool(TB,ID,Label,BitmapEn),
    wxBitmap:destroy(BitmapEn).

