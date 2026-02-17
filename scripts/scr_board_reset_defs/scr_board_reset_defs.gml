///
function scr_board_reset_defs(){
with (obj_ctrl) {
	
	show_debug_message("scr_board_reset_defs")
	
	with (obj_tile_letter) {
		instance_destroy()
	}
	with (obj_tile_space) {
		instance_destroy()
	}

	
			
				
	global.loadSecret = ""
	global.loadBoard = ""
	global.current_copy_code = ""
	global.current_copy_link = ""
	
	//if obj_ctrlp.level_status >= LEVEL_STATUS_Started {
	//	obj_ctrlp.level_status = LEVEL_STATUS_NotStarted
	//	show_debug_message("reseting level_status to NotStarted")
	//}
			
			
	//reset arrays
	selected_word_length = 0
	selected_word_str = ""
	selected_word_array = 0
	selected_word_array_id = 0
	selected_word_latest_tile = -1
	selected_word_latest_tile_id = -1
	selected_word_not_in_dictionary = 0
	selected_word_is_valid = 0
	selected_word_base_points = 0

	secret_word_length = 0
	secret_word_str = ""
	secret_word_array = 0

	guesses_count = 0
	guesses_list = 0
	guesses_list[1] = ""
			
	game_finished = 0
			
	global.gave_up = 0
			
	//
	if global.is_reddit != 1 {
		scr_update_copy_code()
	}
	
}
}