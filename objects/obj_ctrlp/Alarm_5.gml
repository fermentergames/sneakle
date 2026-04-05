

//if both postData and state loaded, get the board data and init the board
if global.game_loading != 0 {
	
	show_debug_message("alarm[5], waiting to load")
	
	show_debug_message("load_post_data_complete = "+string(load_post_data_complete))
	show_debug_message("load_state_complete = "+string(load_state_complete))
			
	if load_post_data_complete = 1 && load_state_complete = 1 {
		
		
		if string(global.launch_into_create_mode) != "true" { //skip this part if launching into create mode
			
			show_debug_message("setting game_phase = 0 from alarm[5]")
			global.loadBoard = ""
			global.game_phase = 0
			scr_board_reset_defs()
	
		}
		
		show_debug_message("postData_levelTag = "+string(postData_levelTag))
		show_debug_message("postData_levelCreator = "+string(postData_levelCreator))
		show_debug_message("username = "+string(username))
		
		if already_finished < 3 {
			if postData_levelTag = "community" {
				if postData_levelCreator != "" && username != "" {
					if postData_levelCreator = username {
						show_debug_message("postData_levelCreator = username, set already_finished = 3 to disable scoring on own puzz")
						already_finished = 3
						level_status = LEVEL_STATUS_IsAuthor
						api_save_state(postId,{level_status},undefined)
					}
				}
			}
		}
		
		show_debug_message("already_finished = "+string(already_finished))
		
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