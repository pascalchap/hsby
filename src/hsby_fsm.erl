-module(hsby_fsm).

-include("hsby.hrl").

-behaviour(gen_fsm).

-define(SERVER, ?MODULE).

-record(state, {plca  = a}).

%% export interfaces
-export([start_link/1]).

%% export callbacks
-export([init/1, handle_info/3, terminate/3, code_change/4, handle_event/3, handle_sync_event/4]).

%% export states
-export([init_hsby/2, init_hsby/3,get_new_hsby_state/1]).

%% INTERFACES %%

start_link(Args) ->
	gen_fsm:start_link({local, ?SERVER}, ?MODULE, Args, []).

get_new_hsby_state(Args) ->
	gen_fsm:sync_send_all_state_event(?SERVER, {get_new_state,Args}).

%% CALLBACK FUNCTIONS %%
%% @private
%%	init(Args) -> Result
%%
%%	Types:
%%		Args = term()
%%		Result = {ok,StateName,StateData} | {ok,StateName,StateData,Timeout}
%%			| {ok,StateName,StateData,hibernate}
%%			| {stop,Reason} | ignore
%%		StateName = atom()
%%		StateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

init(_Args) ->
	{ok, init_hsby, #state{}}.

%% @private
%%	StateName(Event, StateData) -> Result
%%	
%%	Types:
%%		Event = timeout | term()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

 init_hsby(_Event, State) ->
	{next_state, init_hsby, State}.

%% @private
%%	StateName(Event, From, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		From = {pid(),Tag}
%%		StateData = term()
%%		Result = {reply,Reply,NextStateName,NewStateData}
%%			| {reply,Reply,NextStateName,NewStateData,Timeout}
%%			| {reply,Reply,NextStateName,NewStateData,hibernate}
%%			| {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,Reply,NewStateData} | {stop,Reason,NewStateData}
%%		Reply = term()
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = normal | term()
 
 init_hsby(_Event, _From, State) ->
	{reply, ok, init_hsby, State}.

%% @private
%%	handle_event(Event, StateName, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		StateName = atom()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

handle_event(_Event, StateName, State) ->
	{next_state, StateName, State}.

%% @private
%%	handle_sync_event(Event, From, StateName, StateData) -> Result
%%
%%	Types:
%%		Event = term()
%%		From = {pid(),Tag}
%%		StateName = atom()
%%		StateData = term()
%%		Result = {reply,Reply,NextStateName,NewStateData}
%%			| {reply,Reply,NextStateName,NewStateData,Timeout}
%%			| {reply,Reply,NextStateName,NewStateData,hibernate}
%%			| {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,Reply,NewStateData} | {stop,Reason,NewStateData}
%%		Reply = term()
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = term()

handle_sync_event({get_new_state,Args}, _From, StateName, State) ->
	 %% io:format("--->>> Hsby fsm evaluation~n"),
	{reply, Args, StateName, State};
handle_sync_event(_Event, _From, StateName, State) ->
	{reply, ok, StateName, State}.

%% @private
%%	handle_info(Info, StateName, StateData) -> Result
%%
%%	Types:
%%		Info = term()
%%		StateName = atom()
%%		StateData = term()
%%		Result = {next_state,NextStateName,NewStateData}
%%			| {next_state,NextStateName,NewStateData,Timeout}
%%			| {next_state,NextStateName,NewStateData,hibernate}
%%			| {stop,Reason,NewStateData}
%%		NextStateName = atom()
%%		NewStateData = term()
%%		Timeout = int()>0 | infinity
%%		Reason = normal | term()

handle_info(_Info, StateName, State) ->
	{next_state, StateName, State}.

%% @private
%%	terminate(Reason, StateName, StateData)
%%
%%	Types:
%%		Reason = normal | shutdown | {shutdown,term()} | term()
%%		StateName = atom()
%%		StateData = term()

terminate(_Reason, _StateName, _State) ->
	ok.

%% @private
%%	code_change(OldVsn, StateName, StateData, Extra) -> {ok, NextStateName, NewStateData}
%%
%%	Types:
%%		OldVsn = Vsn | {down, Vsn}
%%		Vsn = term()
%%		StateName = NextStateName = atom()
%%		StateData = NewStateData = term()
%%		Extra = term()

code_change(_OldVsn, StateName, State, _Extra) ->
	{ok, StateName, State}.

%% LOCAL FUNCTIONS %%
