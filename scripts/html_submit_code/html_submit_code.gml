/// @param element
function html_submit_code(argument0) {
	
	var element = argument0;
	var values = html_form_values(element);

	loadCode = values[? "loadCode"];
	form_is_loading = true
	alarm[1] = 90;
	
	show_debug_message("SUBMITTED!")
	show_debug_message(loadCode)
	
	//if global.loadBoard != "" && global.loadSecret != "" {
	//	scr_board_init()
	//}
	
	global.show_input_prompt = 0
	form_is_loading = false;
	

	
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

}
