if (live_call()) return live_result;

draw_set_font(fnt_main)
//if os_type == os_windows || os_type == os_macosx {
//	device_mouse_dbclick_enable(false);
//} else {
//	device_mouse_dbclick_enable(true);
//}

var _letter_hue = 160
global.background_col = make_color_hsv(_letter_hue,110,30)
var background = layer_background_get_id(layer_get_id("Background"));
layer_background_blend(background, global.background_col)

device_mouse_dbclick_enable(false);

global.grid_x_origin = 0
global.grid_y_origin = 0

global.sw = browser_width
global.sh = browser_height
global.cam_zoom = 1
global.cam_zoom_fd = 1

global.letters_grid = ""
global.letters_bag = ""

global.am_creating_fd = 1
global.am_creating_fd2 = 1

global.am_creating = 0

global.am_generate_random = 0

global.gave_up = 0
global.game_mode = 1
global.points_total = 0
global.words_made = 0
global.rearranges_used = 0
global.discards_used = 0

global.game_grid_size = 4
global.game_grid_size_sqr = sqr(global.game_grid_size)
global.tile_size = 64
global.pad_size = 0

global.loadBoard = ""
global.loadSecret = ""
global.show_any_menu = 0
global.show_any_menu_fd = 0
global.show_input_prompt = 0
global.show_export_prompt = 0
global.show_archives = 0

global.tile_style = 1
global.tile_raises = 0

global.current_copy_code = "ABCD_1-2-3-4"
global.current_copy_url = "https://fermentergames.github.io/Sneakle/?loadBoard=ABCD&loadSecret=1-2-3-4"

global.dictionary = new CheckWordDictionary(working_directory + "dictionaries/full/full.txt");
global.dictionary_simple = new CheckWordDictionary(working_directory + "dictionaries/simple/full.txt");

global.dictionary_generate = new PickWordDictionary(working_directory + "dictionaries/simple_by_length/5.txt");

global.generated_word = "HARMONY"

scr_letter_data_init()

//am_screenshotting = 0
//am_screenshotting_fd = 0

//donate_button = -1
//fullscreen_button = -1
//alarm[0] = 30

global.is_browser = 0
if os_browser != browser_not_a_browser {
	global.is_browser = 1	
}

global.game_grid_size = 4

curr_width = browser_width
curr_height = browser_height
//if global.is_browser = 1 {
event_user(0);

if global.is_browser = 1 {
	
	

} else {
	if !instance_exists(obj_gmlive) {
		instance_create_layer(x,y,layer,obj_gmlive)
	}
}

if !instance_exists(obj_ctrlp) {
	instance_create_layer(x,y,layer,obj_ctrlp)
}


timey = 0

global.game_phase = 0
just_phase_changed = 0

ready_for_phase2 = 0
ready_for_phase2_fd = 0

ready_for_phase3 = 0

dragging = 0
dragging_fd = 0
selecting = 0

selected_word_length = 0
selected_word_str = ""
selected_word_array = 0
selected_word_array_id = 0
selected_word_latest_tile = -1
selected_word_latest_tile_id = -1
selected_word_not_in_dictionary = 0
selected_word_is_valid = 0
selected_word_already_guessed = 0
selected_word_base_points = 0

secret_word_length = 0
secret_word_str = ""
secret_word_array = 0

guesses_count = 0
guesses_list = 0
guesses_list[1] = ""



randomize()

p_string = 0 //reset
get_query()

//if global.loadBoard = "" && global.loadSecret = "" {
	
//	show_debug_message("no query loaded, try to load from parent")
	
//	global.loadBoard = useParentLoadBoardQueryString()
//	global.loadSecret = useParentLoadSecretQueryString()
	
//	show_debug_message("global.loadBoard = "+string(global.loadBoard))
//	show_debug_message("global.loadSecret = "+string(global.loadSecret))
	
//	//changeQuery("loadBoard",string(returnStr[0]),"loadSecret",returnStr[1])
	
//	if global.loadBoard != "" && global.loadSecret != "" && global.loadBoard != "undefined" && global.loadSecret != "undefined" && global.loadBoard != undefined && global.loadSecret != undefined {
//		scr_board_init()
//	}
//}

form_is_loading = false;

//global.loadBoard = "THAINORAYMFUJCET"
//global.loadSecret = "2-6-10-15"

//html_init()
//html_style()

// To use this extension, you need to call #html_init() and optionally #html_style() during initialisation, 
// and #html_sync() in an draw GUI end event

var _gamestart_str = "GameStart"
if global.loadBoard != "" && global.loadSecret != "" {
	_gamestart_str = "GameStart_GonnaLoad"
}

var _event_struct = { //
	screen_name: string(_gamestart_str),
};
GoogHit("screen_view",_event_struct)


