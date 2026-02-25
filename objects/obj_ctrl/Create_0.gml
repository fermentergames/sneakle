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
global.ar = global.sw/global.sh
global.cam_zoom = 1
global.cam_zoom_fd = 1

global.letters_grid = ""
global.letters_bag = ""

global.am_creating_fd = 1
global.am_creating_fd2 = 1

global.am_creating = 0
global.skip_create = 0

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
global.show_any_modal = 0
global.show_any_modal_fd = 0
global.show_input_prompt = 0
global.show_export_prompt = 0
global.show_archives = 0
global.show_lb = 0
global.show_howto = 0
global.show_options = 0
global.show_submitting_post = 0

global.show_lb_fd = 0
global.show_howto_fd = 0
global.show_options_fd = 0

global.tile_style = 1
global.tile_raises = 0

global.current_copy_code = "ABCD_1-2-3-4"
global.current_copy_url = "https://fermentergames.github.io/Sneakle/?loadBoard=ABCD&loadSecret=1-2-3-4"

global.generated_word = "HARMONY"



//am_screenshotting = 0
//am_screenshotting_fd = 0

//donate_button = -1
//fullscreen_button = -1
//alarm[0] = 30

global.is_browser = 0
if os_browser != browser_not_a_browser {
	global.is_browser = 1	
}



var _info_ds_map = os_get_info();

show_debug_message("os_get_info()")
show_debug_message(_info_ds_map)
show_debug_message(_info_ds_map[? "mobile"])

//doesn't work on html5, only reddit
global.is_mobile = 0
if _info_ds_map[? "mobile"] = 1 {
	global.is_mobile = 1
	show_debug_message("mobile detected")
} else {
	show_debug_message("mobile NOT detected")	
}

var _info_href = _info_ds_map[? "window.location.href"]
show_debug_message("_info_href: "+string(_info_href))
global.is_reddit = 0
if string_count("devvit",_info_href) > 0 {
	global.is_reddit = 1
	show_debug_message("Reddit detected")
} else {
	show_debug_message("Reddit NOT detected")	
}


show_debug_message("--");
var map_string = json_encode(_info_ds_map);
show_debug_message(map_string);


ds_map_destroy(_info_ds_map) 



global.game_grid_size = 4

gui_pos_scl = 1
gui_sz_scl = 1
gui_txt_scl = 1

gui_panel_bottom_y = 1
gui_panel_top_y	 = 1
gui_panel_mid_y	 = 1
gui_nav_mid_y		 = 1
gui_footer_top_y =	1
gui_footer_mid_y =	1


curr_width = browser_width
curr_height = browser_height
//if global.is_browser = 1 {
event_user(0);

if global.is_browser = 1 {
	//
} else {
	if !instance_exists(obj_gmlive) {
		instance_create_layer(x,y,layer,obj_gmlive)
	}
}

if !instance_exists(obj_ctrlp) {
	instance_create_layer(x,y,layer,obj_ctrlp)
}


timey = 0
pulse_1 = sin(timey*0.09)
pulse_2 = sin(timey*0.23)
pulse_3 = sin(timey*0.6)
pulse_4 = sin(timey*0.02)
pulse_5 = 0

global.game_phase = 0
global.game_timer = 0
global.game_timer_meta = 0

global.game_hints_used = 0
global.game_hint_length_used = 0
global.game_hint_letter_used = 0

global.game_score_guesses_and_hints = 0
global.game_score_time_bonus = 0
global.game_score_total = 0

ctrl_fd = 0

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
selected_word_latest_tile_id = noone
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

global.tile_letter[1] = -1

glow_trail_fd = 0
glow_trail_letter = 1
glow_trail_perc = 0
gx1 = 0
gy1 = 0

gdir = 0
gdir_fd = 0

game_finished = 0
game_finished_fd = 0
game_finished_delay = 0
game_finished_delay_max = 120

game_finished_fd2 = 0

game_finished_flash = 0
game_finished_flash2 = 0

swipe_allowed_distance = 110

hovered_over_changer = 0
hovered_over_changer_timey = 0


randomize()

p_string = 0 //reset

if global.is_reddit = 1 {
	//get_query_reddit() //handled in obj_ctrlp create with http response
} else {
	get_query()
}
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

async_msg_letters = -1
create_typed_letters = ""

async_msg_title = -1
create_title = ""

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


