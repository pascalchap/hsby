
-module(hsby_cpu_sup).

-behaviour(supervisor).

%% API
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(N,I, Type), {N, {I, start_link, []}, permanent, 5000, Type, [I]}).
-define(CHILD(N,I, Type,Arg), {N, {I, start_link, [Arg]}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link(Init_File) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Init_File).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init(Init_File) ->
	Childs = [?CHILD(plcmanager,plcmanager,worker,Init_File),
			  ?CHILD(cpu_fsm,cpu_fsm,worker,[]),
			  ?CHILD(hsby_fsm,hsby_fsm,worker,[]),
			  ?CHILD(diagmanager,diagmanager,worker,[])],
    {ok, { {one_for_one, 5, 10}, Childs} }.





