-module(hsby_cpu).

-export([start/0,stop/0]).

start() -> 
	observer:start(),
	application:start(hsby_cpu).

stop() -> application:stop(hsby_cpu).