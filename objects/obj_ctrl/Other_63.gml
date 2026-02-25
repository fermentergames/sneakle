if (live_call()) return live_result;

var _id = ds_map_find_value(async_load, "id");
if (_id == async_msg_letters)
{
    if (ds_map_find_value(async_load, "status"))
    {
        if (ds_map_find_value(async_load, "result") != "")
        {
            create_typed_letters = ds_map_find_value(async_load, "result");
				
				scr_submit_typed_letters(create_typed_letters)
				
        }
    } else {
		//cancelled 
	 }
}
else if (_id == async_msg_title)
{
    if (ds_map_find_value(async_load, "status"))
    {
        if (ds_map_find_value(async_load, "result") != "")
        {
            create_title = ds_map_find_value(async_load, "result");
				
				scr_submit_created_puzzle(create_title)
				
        } else {
				//empty title submitted
				//global.show_submitting_post = 0 
				
				create_title = ""
				if obj_ctrlp.username != "" {
					create_title = string(obj_ctrlp.username)
					create_title += "'s Custom Puzzle"
				} else {
					create_title = "Custom Puzzle"
				}
				
				scr_submit_created_puzzle(create_title)
				
				
		  }
    } else {
		 
		 //cancelled
		 global.show_submitting_post = 0
	 }
}