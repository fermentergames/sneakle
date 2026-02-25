///
function scr_submit_typed_letters(_letters) {
	if (live_call(argument0)) return live_result;
	
	//var element = argument0;
	//var values = html_form_values(element);

	//loadCode = values[? "loadCode"];
	//form_is_loading = true
	//alarm[1] = 90;
	
	show_debug_message("LETTERS TYPED!")
	show_debug_message(_letters)
	
	//if global.loadBoard != "" && global.loadSecret != "" {
	//	scr_board_init()
	//}
	
	global.show_input_prompt = 0
	form_is_loading = false;
	
	if string_length(_letters) > 0 {
			
		var sqrd_l = sqr(floor(sqrt(string_length(_letters))))
		_letters = string_copy(_letters, 1, sqrd_l); 
			
		//changeQuery("loadBoard",string(_letters),"loadSecret","")
		//reloadPage()
		

		
		with (obj_tile_letter) {
			instance_destroy()
		}
		with (obj_tile_space) {
			instance_destroy()
		}

		global.am_creating = 1
		var _event_struct = { //
			screen_name: "NewLetters"+string(global.game_grid_size),
		};
		GoogHit("screen_view",_event_struct)
				
		global.loadSecret = ""
		global.loadBoard = _letters
		global.current_copy_code = ""
		global.current_copy_link = ""
		scr_update_copy_code()
				
		scr_board_init()

				
		with (obj_tile_letter) {
			//instance_destroy()
			image_angle = 0
			born_fd = 1
			spawn_slam = 0
			am_set = 1
			am_set_fd = 1
			am_set_flash = 0
			x = x_targ
			y = y_targ
		}
		
		
		
	} else {
		//changeQuery("loadBoard","","loadSecret","")
		//html_submit_closebtn()
	}
	

	/*
	var underscorePos = string_pos("_", loadCode);
	var returnStr;

	if (underscorePos != 0) {
		
		returnStr[0] = string_upper(string_delete(loadCode, underscorePos, string_length(loadCode) - underscorePos + 1));
		returnStr[1] = string_copy(loadCode, underscorePos+1, string_length(loadCode) - underscorePos + 1);

		var sqrd_l = sqr(floor(sqrt(string_length(returnStr[0]))))
		returnStr[0] = string_copy(returnStr[0], 1, sqrd_l);

		changeQuery("loadBoard",string(returnStr[0]),"loadSecret",returnStr[1])
		reloadPage()

	} else {
		
		loadCode = string_upper(string_letters(loadCode))
		
		
		
		if string_length(loadCode) > 0 {
			
			var sqrd_l = sqr(floor(sqrt(string_length(loadCode))))
			loadCode = string_copy(loadCode, 1, sqrd_l);
			
			changeQuery("loadBoard",string(loadCode),"loadSecret","")
			reloadPage()
		} else {
			changeQuery("loadBoard","","loadSecret","")
			html_submit_closebtn()
		}

		
	}


	ds_map_destroy(values)
	*/


}