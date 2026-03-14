if (1= 0 ) { //prev_points != points) {
	prev_points = points;
	api_save_state(postId, { points }, function(_status, _ok, _result) {
		alarm[0] = 60;
	});
}
//else alarm[0] = 60;

if level_status >= LEVEL_STATUS_GaveUp {
	already_finished = 1
	show_debug_message("level_status >= LEVEL_STATUS_GaveUp, set already_finished")
				
	//scr_board_init will trigger game to autocomplete
}

