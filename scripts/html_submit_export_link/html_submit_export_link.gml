/// @param element
function html_submit_export_link(argument0) {
	
	var element = argument0;
	var values = html_form_values(element);

	exportLink = values[? "exportLink"];
	form_is_loading = true
	//alarm[1] = 90;
	
	show_debug_message("exporting link!")
	show_debug_message(exportLink)
	
	//if global.loadBoard != "" && global.loadSecret != "" {
	//	scr_board_init()
	//}
	
	global.show_export_prompt = 0
	form_is_loading = false;
	
	copyToClipboard("Can you find the hidden word? "+string(exportLink))
	
	
	//clipboard_set_text(string(exportLink));
	//show_message("copied link!\n"+string(exportLink))
	
	ds_map_destroy(values)

}
