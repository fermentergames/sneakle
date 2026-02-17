
if puzzle_is_daily = 1 {
	
	api_get_surrounding_daily_ids(postId, function(_status, _ok, _result) {
		try {
			var _surrounding_res = json_parse(_result);
			show_debug_message("api_get_surrounding_daily_ids GOT!")
							
			surrounding_res = _surrounding_res
			surrounding_res_str = json_stringify(_surrounding_res,true)
			
			show_debug_message(surrounding_res_str)
			
			daily_prev_postId = "-9999"//reset
			daily_next_postId = "-9999"//reset
		
			daily_prev_postId = _surrounding_res.daily_prev_postId;
			show_debug_message(daily_prev_postId)
			daily_next_postId = _surrounding_res.daily_next_postId;
			show_debug_message(daily_next_postId)	
		
		}
		catch (_ex) {
			show_debug_message("api_get_surrounding_daily_ids FAILED!")
			alarm[6] = 60;
		}
		
	});
}