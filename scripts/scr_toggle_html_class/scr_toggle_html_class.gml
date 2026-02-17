///
function scr_toggle_html_class(target, className){
	
	var data = {
		"type": "TOGGLE_CLASS",
      "target": target,
      "className": className
   };
	
	show_debug_message("Try scr_toggle_html_class(), data = "+string(json_stringify(data)))

   window_post_message(json_stringify(data));

}
