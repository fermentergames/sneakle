///
if (live_call()) return live_result;




if am_dragging >= 1 {
	
	var _swapped_letter = 0
	var _rearranged = 0
	
	if	scr_mouse_over_button((global.sw*0.5)+(148*obj_ctrl.gui_sz_scl),global.sh-(240*obj_ctrl.gui_sz_scl),0.25*obj_ctrl.gui_txt_scl,0.12*obj_ctrl.gui_txt_scl) {
		show_debug_message("WOAH")
	
		//if (device_mouse_x_to_gui(0)*global.pr) <= ((global.sw*0.5)+(148*obj_ctrl.gui_sz_scl)) {
		//	show_debug_message("-1")
		//	if my_letter_num > 1 {
		//		my_letter_num -= 1	
		//	} else {
		//		my_letter_num = 26
		//	}
		//} else {
		//	show_debug_message("+1")
		//	if my_letter_num < 26 {
		//		my_letter_num += 1	
		//	} else {
		//		my_letter_num = 1	
		//	}
		//}
		//my_letter_str = global.letter_data[my_letter_num,1]
		
		_swapped_letter = 1
	
	} 
	
	if 1=1 {
	
		am_dragging = 0
	
		prev_targ_id = targ_id
		prev_tile_id = tile_id
		targ_id = instance_nearest(x,y,obj_tile_space)
		tile_id = targ_id.tile_id
		//global.tile_letter[tile_id] = id
	
	
	
	
		obj_ctrl.dragging = 0
	
		if point_distance(x,y,targ_id.x,targ_id.y) > 40 || _swapped_letter {
			targ_id = prev_targ_id
			tile_id = prev_tile_id
		}
	
		if 1=1 { //if point_distance(x,y,targ_id.x,targ_id.y) <= 40 {
	
			if prev_targ_id != targ_id && prev_targ_id != self {
				global.rearranges_used += 1
				show_debug_message("rearranges_used: "+string(global.rearranges_used))
				_rearranged = 1
			}
		
			var _conflicting_tile = collision_point(targ_id.x,targ_id.y,obj_tile_letter,true,true)
		
			if _conflicting_tile != noone {
				with (_conflicting_tile) {
					if other.am_set = 1 { //swap with other tile's target
					
						am_set = 1
						targ_id = other.prev_targ_id
						prev_targ_id = targ_id
						x_targ = targ_id.x
						y_targ = targ_id.y
					
						tile_id = targ_id.tile_id
						//global.tile_letter[tile_id] = id
					
					} else { //conflict with a tile that hasn't been set yet, so just reset
				
						//reset
						am_set = 0 
						targ_id = self
						prev_targ_id = self
						x_targ = xstart
						y_targ = ystart
					

					}
				}
			}
		
		
		
			x_targ = targ_id.x
			y_targ = targ_id.y
			am_set = 1
			prev_targ_id = targ_id
			am_set_flash = 1
			
			audio_play_sound(snd_mm_click_003,0,0,0.1,0,0.95+random(0.02))
		
	
		} else { //dragged out of grid area
		
		
		
			if 1=1 && global.game_mode = 2 {
						
				with (instance_create_depth(prev_targ_id.x,prev_targ_id.y,depth,obj_tile_letter)) {
					tile_id = other.prev_tile_id
					tile_col = other.tile_col
					tile_row = other.tile_row
					targ_id = other.prev_targ_id
					global.tile_letter[tile_id] = id

					spawn_slam = 2+(-0.5*tile_col*(1/global.game_grid_size))+(-0.5*tile_row*(1/global.game_grid_size))
				
					image_angle = (-20+random(40))		
					//my_letter_str = string_upper(global.letters_bag[tile_id])
					//take first array entry
					my_letter_str = array_shift(global.letters_bag)
					//replace letters array end
					array_push(global.letters_bag,my_letter_str)
							
					am_set = 1
				
					for (var l = 1; l <= array_length(global.letter_data); ++l) {
						if my_letter_str = global.letter_data[l,1] {
							my_letter_num = l
							l = array_length(global.letter_data)
						}
					}
				}
			
				//assign all tiles to corresponding space
				with (obj_tile_letter) {	
					tile_id = targ_id.tile_id
					global.letters_grid[tile_id] = my_letter_str
					global.tile_letter[tile_id] = id
				}

				scr_update_copy_code()
				
				obj_ctrl.selected_word_is_valid = 0//reset
			
				global.discards_used += 1
				show_debug_message("discards_used: "+string(global.discards_used))
						
				//now destroy the original one
				instance_destroy()
				
				audio_play_sound(snd_mm_click_003,0,0,0.1,0,0.95+random(1))
			
			} else {
		
				if point_distance(x,y,xstart,ystart) <= 999940 {
					x_targ = xstart
					y_targ = ystart
				}
		
				targ_id = self
				prev_targ_id = targ_id
				am_set = 0
				
				audio_play_sound(snd_mm_click_003,0,0,0.1,0,0.95+random(1))
		
			}

		
		}
	
	}
	
	
	//assign all tiles to corresponding space
	with (obj_tile_letter) {
		tile_id = targ_id.tile_id
		global.letters_grid[tile_id] = my_letter_str
		global.tile_letter[tile_id] = id
	}
	
	if _rearranged = 1 {
		global.loadSecret = ""
		global.loadBoard = ""
		global.current_copy_code = ""
		global.current_copy_link = ""
		scr_update_copy_code()	
	}
	
	
}





