///
function scr_update_copy_code(){
	if (live_call()) return live_result;
	
	global.current_copy_code = ""
	//global.current_copy_url = "https://fermentergames.github.io/Sneakle/?loadBoard=ABCD&loadSecret=1-2-3-4"
	show_debug_message("get_window_host()")
	show_debug_message(get_window_host())
	global.current_copy_url = string(get_window_host())
	global.current_copy_url += "?loadBoard="
	
	var queryStr = 0
	queryStr[0] = ""
	queryStr[1] = ""
	

	
	for (var l = 1; l <= global.game_grid_size_sqr; ++l) {
		global.current_copy_code += global.letters_grid[l]
		global.current_copy_url += global.letters_grid[l]
		queryStr[0] += global.letters_grid[l]
		//show_debug_message(global.letters_grid[l])
	}
	

	
	global.current_copy_code += "_"
	global.current_copy_url += "&loadSecret="
	
	for (var l = 0; l < obj_ctrl.secret_word_length; ++l) {
		global.current_copy_code += string(obj_ctrl.secret_word_array[l])
		global.current_copy_url += string(obj_ctrl.secret_word_array[l])
		queryStr[1] += string(obj_ctrl.secret_word_array[l])
		
		if l < obj_ctrl.secret_word_length-1 {
			global.current_copy_code += "-"
			global.current_copy_url += "-"
			queryStr[1] += "-"
		}
		
		
	}
	

	
	show_debug_message("global.current_copy_code:")
	show_debug_message(global.current_copy_code)
	
	show_debug_message("global.current_copy_url:")
	show_debug_message(global.current_copy_url)
	

	
	changeQuery("loadBoard",string(queryStr[0]),"loadSecret",queryStr[1])
	

	
	/////////////////////////////////////////
	
	

	
	
}