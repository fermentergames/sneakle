///
function get_query() {
if (live_call()) return live_result;
	var p_num;
	p_num = parameter_count();
	if (p_num > 0) {
	   var i;
	   for (i = 0; i < p_num; i += 1) {
	      p_string[i] = parameter_string(i + 1);
			parse_query(p_string[i])
	   }
		
		show_debug_message("query string array created")
		show_debug_message(p_string)
		
		if global.loadBoard != "" {//&& global.loadSecret != "" {
			global.game_loading = 0
			scr_board_init()
		}
		

	} else {
		show_debug_message("no query string")
		return false;	
	}

}


function get_query_reddit() {
if (live_call()) return live_result;

	
	if obj_ctrlp.postData != undefined {//|| 1=1 {
	
		//obj_ctrlp.postData_gameData = "loadBoard=DARKNESSHELLFIRE&loadSecret=8-11-10-5-1-6-3"
	
		var _postData_gameData_str_full = string(obj_ctrlp.postData_gameData);
		var _postData_gameData_str;
	
		var ampPos = string_pos("&", _postData_gameData_str_full);
	
		_postData_gameData_str[1] = string_delete(_postData_gameData_str_full, ampPos, string_length(_postData_gameData_str_full) - ampPos + 1);
		_postData_gameData_str[2] = string_copy(_postData_gameData_str_full, ampPos+1, string_length(_postData_gameData_str_full) - ampPos + 1);
	
		show_debug_message("_postData_gameData_str[1]")
		show_debug_message(_postData_gameData_str[1])
		show_debug_message("_postData_gameData_str[2]")
		show_debug_message(_postData_gameData_str[2])

		parse_query(_postData_gameData_str[1])
		parse_query(_postData_gameData_str[2])
		
		show_debug_message("Reddit query string array created")
		
		if global.loadBoard != "" {//&& global.loadSecret != "" {
			global.game_loading = 0
			
			scr_board_init()
		}
		

	} else {
		show_debug_message("Reddit no query string / postData")
		return false;	
	}

}


function parse_query(_query_string) {
if (live_call(argument0)) return live_result;

	var equalPos = string_pos("=", _query_string);
	var returnStr;

	if (equalPos != 0) {
		returnStr[0] = string_delete(_query_string, equalPos, string_length(_query_string) - equalPos + 1);
		//returnStr[1] = string_delete(_query_string, 0, equalPos + 1); //wrong and unneeded
		returnStr[2] = string_copy(_query_string, equalPos+1, string_length(_query_string) - equalPos + 1);
	  
		show_debug_message("returnStr[0]")
		show_debug_message(returnStr[0])
		//show_debug_message("returnStr[1]")
		//show_debug_message(returnStr[1])
		show_debug_message("returnStr[2]")
		show_debug_message(returnStr[2])
	  
		if returnStr[0] = "loadBoard" {
			global.loadBoard = returnStr[2]
		}
		if returnStr[0] = "loadSecret" {
			global.loadSecret = returnStr[2]
		}
		
		
	  
		return returnStr;
		
	} else {
		//Not a valid query string
		show_debug_message("query string had no equals sign")
		return false;
	}
	
	
	
}