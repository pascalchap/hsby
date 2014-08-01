-define(TICK, 100).

-record(hsbysts, {
	hsby_link_error,
	rio_link_error,
	on_line,
	state = init, %% can take values init, off_line, primary, standby
	hsby = undefined, %% can take values master, not_master, potential, undefined
	plc, % can take value a or b
	rio_error,
	sdcard,
	register
}).

-record(hsbyddt, {
	local = #hsbysts{},
	remote = #hsbysts{},
	remote_sts_valid = false,
	app_mismatch_allowed = false,
	app_mismatch,
	fw_mismatch_allowed = false,
	fw_update_in_run_allowed =false,
	fw_mismatch,
	data_layout_mismatch,
	sdcard_app_mismatch,
	backup_app_mismatch,
	cde_swap = false,
	cde_app_transfer = false
	}).

-record(cpu, {
	app_id = app1,
	data_mast_size = 200000,
	data_safe_size = 50000,
	data_fast_size = 5000,
	sdcard = true,
	sdcard_app_id = app1,
	backup_app_id = app1,
	autorun = true,
	power = on,
	state = noconf %% can take noconf, stop, run, halt, err
}).

-record(diag, {
	count = 0
}).

-record(task, {
	name, 
	period, 
	manager, 
	mode, 
	run, 
	exe, 
	remain, 
	priority, 
	initfunc=[], 
	runfunc=[],
	func=none,
	diag = #diag{}   %% valid only for mast task
}).
