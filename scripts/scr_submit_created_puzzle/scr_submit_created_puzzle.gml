///
function scr_submit_created_puzzle(_title) {
	if (live_call(argument0)) return live_result;
	
	//var element = argument0;
	//var values = html_form_values(element);

	//loadCode = values[? "loadCode"];
	//form_is_loading = true
	//alarm[1] = 90;
	
	show_debug_message("SUBMITTED TITLE!")
	show_debug_message(_title)
	
	show_debug_message("now get puzzle data + username, and submit as custom post via API call, then wait for success")
	

	with (obj_ctrlp) {
		if 1=1 {//global.is_reddit = 1 {
			
			var _username = string(obj_ctrlp.username)
			var _puzzle_data = string(global.current_copy_url)
			
			show_debug_message(_username)
			show_debug_message(_puzzle_data)
			
			//
			
			api_create_user_post(_username, _title, _puzzle_data, function(_status, _ok, _result) {
				
				
				show_debug_message("api_create_user_post callback happening")
				
				show_debug_message(_status);
				show_debug_message(_ok);
				show_debug_message(_result);
				
				if (_status = 0) {
			      show_debug_message("post created!");
					show_debug_message("result should be post to nav to??");
					show_debug_message(_result);
					
					show_debug_message("now nav to this new post");
					
					global.show_submitting_post = 2
					
					api_navigateTo(_result,undefined)
					
			   } else {
			      show_debug_message("post creation FAILED: " + string(_result));
			   }
			});
			
		}
	}

}