if (async_load[? "event_type"] == "post_message_received")
{
   var _origin = async_load[? "origin"];
    
   if (_origin != undefined)
   {
      show_debug_message("Message received from: " + string(_origin));
   }
    
   var _data = async_load[? "data"];    
    
   if (_data != undefined)
   {
      show_debug_message("Raw message: " + string(_data));
        
      var json;

		if (is_string(_data) && string_pos("{", _data) == 1) { // If message is a JSON string {
			json = json_parse(_data);
		} else {
			// Already a struct
			json = _data;
		}
		


		if (json != undefined) {
			
			if (variable_struct_exists(json, "type")) {
				if json.type == "devvit-message" {
				   json = json.data;
				   show_debug_message("json.type == 'devvit-message'");
				}
			}
		
			switch (json.action)
			{
			   case "display_message":
			      show_debug_message("display_message happening");
			      show_debug_message(json.msg);
				  global.light_mode = !global.light_mode
				  
			   break;

			   case "load-archive-post":
			      var _postIdToLoad = string(json.postId);
			      show_debug_message("load-archive-post happening: " + _postIdToLoad);
			      if (_postIdToLoad != "") {
					  showGameArchive("false");
					  global.show_archives = 0;
					  scr_reddit_reset_post();
					  scr_reddit_load_post(_postIdToLoad);
				  }
			   break;

			   case "submit-typed-letters":
			      show_debug_message("submit-typed-letters happening");
			      scr_submit_typed_letters(json.letters);
			      html_submit_closebtn();
			   break;

			   case "paste-typed-letters":
			      show_debug_message("paste-typed-letters happening");
			      keyboard_string += string_upper(string_letters(string(json.letters)));
			      alarm[1] = 2 //refresh the input display
			   break;
			   case "set-is-reddit-app":
			      global.is_reddit_app = json.isRedditApp;
			      show_debug_message("is_reddit_app set to " + string(global.is_reddit_app));
			   break;
			                   
			   case "close-modals":
			      show_debug_message("close-modals happening");
			      html_submit_closebtn();
			   break;
			}
		}
    }
}


//if (async_load[? "event_type"] == "virtual keyboard status")
//{

//	var _screen_height = async_load[? "screen_height"];
//	var _keyboard_status = async_load[? "keyboard_status"];
//	var _keyboard_string = string_upper(string_letters(keyboard_string))
	
//	show_debug_message("virtual keyboard status happening")
	
//	show_debug_message("_screen_height = "+string(_screen_height))
//	show_debug_message("_keyboard_status = "+string(_keyboard_status))
//	/*
//	"hiding"
//	"hidden"
//	"showing"
//	"visible"
//	*/
	
//	show_debug_message("_keyboard_string = "+string(_keyboard_string))
	
//	if _keyboard_status == "hiding" {
		
//		show_debug_message("_keyboard_status == 'hiding'")
		
//		if string_length(_keyboard_string) >= 4 {
			
//			show_debug_message("submit-typed-letters from virtual keyboard status happening");
		
//			scr_submit_typed_letters(_keyboard_string);
			
//		} else {
//			show_debug_message("submit-typed-letters not long enough from virtual keyboard...");
//		}
		
//		html_submit_closebtn();	
		
//		show_debug_message("resetting keyboard_string")
//		keyboard_string = ""
		
//	} else {
		
//		show_debug_message("some other _keyboard_status")
		
//	}
	
	
	
	
	
//}