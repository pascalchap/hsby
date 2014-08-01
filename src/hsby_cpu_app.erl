-module(hsby_cpu_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, File) ->
	Init_File = util:get_arg(init,File),
    hsby_cpu_sup:start_link(Init_File).

stop(_State) ->
    ok.
