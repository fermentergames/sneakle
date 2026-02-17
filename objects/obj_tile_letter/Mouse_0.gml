///

if (live_call()) return live_result;



if global.game_phase = 2 || global.game_phase = 3 {
	
	if obj_ctrl.selecting >= 1 {
		if am_selected = 0 {
			if point_distance(x,y,mouse_x,mouse_y) < 30 {
				am_selected = 1
				am_selected_flash = 1
		
				obj_ctrl.selected_word_length += 1
				am_selected_num = obj_ctrl.selected_word_length
		
				obj_ctrl.selected_word_str += string(my_letter_str)
				obj_ctrl.selected_word_latest_tile = tile_id
				obj_ctrl.selected_word_latest_tile_id = id
				obj_ctrl.selected_word_array[obj_ctrl.selected_word_length-1] = tile_id
				obj_ctrl.selected_word_array_id[obj_ctrl.selected_word_length-1] = id
				
				with (obj_ctrl) {
					scr_validate_word()
				}
				
				audio_play_sound(snd_mm_toggle_on,0,0,0.2,0,0.6+(0.06*obj_ctrl.selected_word_length))
				
				
			}
		
		} else if am_selected = 1 && obj_ctrl.selected_word_latest_tile_id != id {
			if point_distance(x,y,mouse_x,mouse_y) < 30 {
				
				
				with (obj_tile_letter) {
					if am_selected_num > other.am_selected_num {
						am_selected = 0
						am_selected_num = 0
					}
				}
				
				var _backup_array = obj_ctrl.selected_word_array
				var _backup_array_id = obj_ctrl.selected_word_array_id
				
				obj_ctrl.selected_word_array = 0 //reset
				obj_ctrl.selected_word_array_id = 0 //reset
				for (var l = 0; l < am_selected_num; ++l) {
					obj_ctrl.selected_word_array[l] = _backup_array[l]
					obj_ctrl.selected_word_array_id[l] = _backup_array_id[l]
				}
				
				
				//obj_ctrl.selected_word_array = array_resize(obj_ctrl.selected_word_array,am_selected_num)
				
				am_selected = 1
				//am_selected_flash = 1
		
				obj_ctrl.selected_word_length = am_selected_num
				//am_selected_num = obj_ctrl.selected_word_length
		
				obj_ctrl.selected_word_str += string(my_letter_str)
				obj_ctrl.selected_word_latest_tile = tile_id
				obj_ctrl.selected_word_latest_tile_id = id
				obj_ctrl.selected_word_array[obj_ctrl.selected_word_length-1] = tile_id
				obj_ctrl.selected_word_array_id[obj_ctrl.selected_word_length-1] = id
				
				audio_play_sound(snd_mm_toggle_off,0,0,0.14,0,0.5+(0.06*obj_ctrl.selected_word_length))
				
				with (obj_ctrl) {
					scr_validate_word()
				}
				
			}
		}
	}

}

