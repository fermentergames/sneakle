

//if both postData and state loaded, get the board data and init the board
if global.game_loading != 0 {
	
	show_debug_message("alarm[5], waiting to load")
	
	show_debug_message("load_post_data_complete = "+string(load_post_data_complete))
	show_debug_message("load_state_complete = "+string(load_state_complete))
			
	if load_post_data_complete = 1 && load_state_complete = 1 {
				
		global.loadBoard = ""
		global.game_phase = 0
		scr_board_reset_defs()
	
		show_debug_message("trying again to load board via get_query_reddit() with postData_gameData")
		get_query_reddit()
		global.game_loading = 0	
		
		
	
	} else {
				
		show_debug_message("load_post_data_complete != 1 || load_state_complete != 1")
				
		if global.loadBoard = "" {
			alarm[5] = 10	
		}
	}
} else {
	show_debug_message("game_loading = 0, don't load board?")
}