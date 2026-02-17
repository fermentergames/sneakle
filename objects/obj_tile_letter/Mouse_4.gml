///

if (live_call()) return live_result;


if global.game_phase = 1 {
	am_dragging = 1
	am_dragging_flash = 1
	
	obj_ctrl.dragging = 1
	
}

if global.game_phase = 2 || global.game_phase = 3 {
	
	with (obj_tile_letter) {
		am_part_of_secret_word = 0	
	}
	
	if am_selected = 0 {
		
		obj_ctrl.selecting = 1
		
		obj_ctrl.selected_word_str = ""//reset
		obj_ctrl.selected_word_length = 0 //reset
		obj_ctrl.selected_word_array = 0//reset
		obj_ctrl.selected_word_array_id = 0 //reset
		obj_ctrl.selected_word_is_valid = 0 //reset
		
		am_selected = 1
		am_selected_flash = 1

		am_selected_start = 1
		am_selected_num = 1
		obj_ctrl.selected_word_length += 1
		
		obj_ctrl.selected_word_str += string(my_letter_str)
		obj_ctrl.selected_word_latest_tile = tile_id
		obj_ctrl.selected_word_latest_tile_id = id
		obj_ctrl.selected_word_array[obj_ctrl.selected_word_length-1] = tile_id
		obj_ctrl.selected_word_array_id[obj_ctrl.selected_word_length-1] = id
		
		audio_play_sound(snd_mm_toggle_on,0,0,0.2,0,0.6+(0.06*obj_ctrl.selected_word_length))
				
	}

}

