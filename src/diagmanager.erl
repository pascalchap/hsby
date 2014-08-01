-module(diagmanager).

-behaviour(gen_server).

-include("hsby.hrl").

-define(SERVER, ?MODULE).

-record(state, {diag=#diag{}}).

%% export interfaces
-export([start_link/1,get_diag/0]).

%% export callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% INTERFACES %%

start_link(Args) ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, Args, []).

get_diag() ->
	gen_server:call(?SERVER,{get_diag}).

%% CALLBACK FUNCTIONS %%
%% @private

%%	init(Args) -> Result
%% 
%%	Types:
%%		Args = term()
%%		Result = {ok,State} | {ok,State,Timeout} | {ok,State,hibernate}
%%		| {stop,Reason} | ignore
%%		State = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

init(_Args) ->
	{ok, #state{}}.

%%	handle_call(Request, From, State) -> Result
%%		
%%	Types:
%%		Request = term()
%%		From = {pid(),Tag}
%%		State = term()
%%		Result = {reply,Reply,NewState} | {reply,Reply,NewState,Timeout}
%%			| {reply,Reply,NewState,hibernate}
%%			| {noreply,NewState} | {noreply,NewState,Timeout}
%%			| {noreply,NewState,hibernate}
%%			| {stop,Reason,Reply,NewState} | {stop,Reason,NewState}
%%		Reply = term()
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

handle_call({get_diag}, _From, #state{diag = Diag} = State) ->
	Diag1 = Diag#diag{count = Diag#diag.count + 1},
	{reply, Diag1, State#state{diag=Diag1}};
handle_call(_Request, _From, State) ->
	{reply, {error, unknown_call}, State}.

%%	handle_cast(Request, State) -> Result
%%	
%%	Types:
%%		Request = term()
%%		State = term()
%%		Result = {noreply,NewState} | {noreply,NewState,Timeout}
%%		 	| {noreply,NewState,hibernate}
%%		 	| {stop,Reason,NewState}
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = term()

handle_cast(_Msg, State) ->
	{noreply, State}.

%%	handle_info(Info, State) -> Result
%%	
%%	Types:
%%		Info = timeout | term()
%%		State = term()
%%		Result = {noreply,NewState} | {noreply,NewState,Timeout}
%%		 	| {noreply,NewState,hibernate}
%%		 	| {stop,Reason,NewState}
%%		NewState = term()
%%		Timeout = int()>=0 | infinity
%%		Reason = normal | term()

handle_info(_Info, State) ->
	{noreply, State}.

%%	terminate(Reason, State)
%%	
%%	Types:
%%		Reason = normal | shutdown | {shutdown,term()} | term()
%%		State = term()

terminate(_Reason, _State) ->
	ok.

%%	code_change(OldVsn, State, Extra) -> {ok, NewState} | {error, Reason}
%%
%%	Types:
%%		OldVsn = Vsn | {down, Vsn}
%%		Vsn = term()
%%		State = NewState = term()
%%		Extra = term()
%%		Reason = term()

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

%% LOCAL FUNCTIONS %%
