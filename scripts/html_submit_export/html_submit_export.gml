/// @param element
function html_submit_export(argument0) {
	
	var element = argument0;
	var values = html_form_values(element);

	exportCode = values[? "exportCode"];
	form_is_loading = true
	//alarm[1] = 90;
	
	show_debug_message("exporting!")
	show_debug_message(exportCode)
	
	//if global.loadBoard != "" && global.loadSecret != "" {
	//	scr_board_init()
	//}
	
	global.show_export_prompt = 0
	form_is_loading = false;
	
	
	copyToClipboard(string(exportCode))
	
	
	//clipboard_set_text(string(exportCode));
	//show_message("copied code!\n"+string(exportCode))
	
	ds_map_destroy(values)

}
