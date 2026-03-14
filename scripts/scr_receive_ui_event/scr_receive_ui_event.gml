///
function scr_receive_ui_event(action) {


	switch (action) {

		case "submit_typed_letters":
			show_debug_message("submit_typed_letters");
			//global.start_game = true;
			break;

		case "request_hint":
			show_debug_message("Hint requested");
			//scr_show_hint();
			break;

	}

}