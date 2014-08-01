-module(util).

-export([tick/4,tick/3,add_default_key/3,get_term/1,get_arg/2]).
-export([on_tick_sec/4,on_tick_mn/4,on_tick_hr/4]).

%% tick(period,message,pid,[tickNumber])

tick(P,M,Pid) -> tick(P,M,Pid,0).

tick(P,M,Pid,V) ->
	receive
		stop -> {stopped_at,V}
	after P ->
		Pid ! {M,V},
		tick(P,M,Pid,V+1)
	end.

add_default_key(Key,Val,Opts) ->
	[{Key,proplists:get_value(Key,Opts,Val)}|proplists:delete(Key,Opts)].

get_term(InitFile) ->
	{ok,Bin} = file:read_file(filename:join("priv",InitFile)),
	{ok,Toks,_} = erl_scan:string(binary_to_list(Bin)),
	erl_parse:parse_term(Toks).

get_arg(Name,Def) ->
	case init:get_argument(Name) of
		{ok,[[L]]} -> L;
		_ -> Def
	end.


on_tick_sec(Module,Function,Arglist,Period) -> 
	on_tick(Module,Function,Arglist,1000,Period,0).
on_tick_mn(Module,Function,Arglist,Period) -> 
	on_tick(Module,Function,Arglist,60000,Period,0).
on_tick_hr(Module,Function,Arglist,Period) -> 
	on_tick(Module,Function,Arglist,60000,Period*60,0).



on_tick(Module,Function,Arglist,TimeBase,Period,Period) ->
	apply(Module,Function,Arglist),
	on_tick(Module,Function,Arglist,TimeBase,Period,0);
on_tick(Module,Function,Arglist,TimeBase,Period,CountTimeBase) ->
	receive
		stop -> stopped
	after TimeBase ->
		on_tick(Module,Function,Arglist,TimeBase,Period,CountTimeBase+1)
	end.
