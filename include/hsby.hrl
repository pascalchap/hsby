-define(TICK, 50).
-define(GEN_EVENT, plcmanager_event).
-define(LOGGER, logger_event).

-define(HSBYSTS, #{
	hsby_link_error => true,
	rio_link_error => true,
	on_line => undefined,
	state => init, %% can take values init, off_line, primary, standby
	hsby => undefined, %% can take values master, not_master, potential, undefined
	plc => undefined, % can take value a or b
	rio_error => undefined,
	sdcard => undefined,
	register => <<0:1024>>
}).

-define(HSBYDDT, #{
	local => ?HSBYSTS,
	remote => ?HSBYSTS,
	remote_sts_valid => false,
	app_mismatch_allowed => false,
	app_mismatch => undefined,
	fw_mismatch_allowed => false,
	fw_update_in_run_allowed =>false,
	fw_mismatch => undefined,
	data_layout_mismatch => undefined,
	sdcard_app_mismatch => undefined,
	backup_app_mismatch => undefined,
	cde_swap => false,
	cde_app_transfer => false
}).

-define(PLC, #{
	start => stop,
	app_id => app1,
	fw_id => 'v1.0',
	plc => a,
	data_mast_size => 50000,
	data_safe_size => 5000,
	data_fast_size => 1000,
	sdcard => false,
	sdcard_app_id => undefined,
	backup_app_id => undefined,
	autorun => false,
	power => on,
	state => noconf %% can take noconf, stop, run, halt, err
}).

-define(DIAG, #{
	count => 0,
	hrtbt => none,
	cpu_state => none
}).

-define(TASK, #{
	name => undefined, 
	period => undefined, 
	manager => undefined, 
	mode => undefined, 
	run => undefined, 
	exe => undefined, 
	remain => undefined, 
	priority => undefined, 
	initfunc => [], 
	runfunc => [],
	func => undefined,
	diag => ?DIAG
}).

-define(HRTBT, #{
	seq_num => 0,
	plc_state => undefined,
	hsby_state => undefined,
	app_id => undefined,
	fw_id => undefined,
	sdcard => undefined,
	sdcard_app_id => undefined,
	backup_app_id => undefined,
	hsby_link_error => undefined,
	rio_link_error => undefined,
	on_line => undefined,
	hsby => undefined, %% can take values master, not_master, potential, undefined
	plc => undefined, % can take value a or b
	rio_error => undefined,
	register => <<0:1024>>
}).