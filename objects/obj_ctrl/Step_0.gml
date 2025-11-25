if (live_call()) return live_result;


//timey = 0
timey += 1


if keyboard_check_pressed(vk_space) {
	
	scr_generate_pick_word()
	
}


if keyboard_check_pressed(vk_alt) {
	
	scr_generate_board_setup()
	
	
}



//if keyboard_check_pressed(vk_space) {
//	if global.game_phase = 1 {
//		global.game_phase = 2	
//	} else {
//		global.game_phase = 1	
//	}
//}
var _pos_scl = global.pr
var _scl = (global.sw/450)
if global.is_landscape = 1 {
	_scl = (global.sh/800)
}
var _tscl = clamp(_scl*1,0.5*global.pr,2*global.pr)




scr_letter_data_init()


if global.game_phase > 0 {
	
	
	if 1=1 {
		var _unplaced_tile_count = -1
		var _empty_tile_count = -1
		var _empty_tile = 0
		ready_for_phase2 = 0

		for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
			
			
			if instance_exists(global.tile_letter[i]) {
				if global.tile_letter[i].am_set = 0 {
					_unplaced_tile_count += 1
				}
			} else {
				_unplaced_tile_count += 1
				show_debug_message("global.tile_letter["+string(i)+"] missing")
			}
			
			if global.tile_space[i].tile_filled = 0 {
				_empty_tile_count += 1
				_empty_tile[_empty_tile_count] = global.tile_space[i].id
			}
			
		}
		
		if _unplaced_tile_count < 0 {// || (_unplaced_tile_count <= 0 && mouse_check_button(mb_left)) {
			ready_for_phase2 = 1
		}
	}
}

if global.game_phase = 2 {
	
	
	if 1=1 {
		
		ready_for_phase3 = 0
		
		if selected_word_is_valid >= 1 && selecting = 0 {//selected_word_length >= 4 && selected_word_not_in_dictionary = 0 {
			ready_for_phase3 = 1
		}
	}
}



if keyboard_check_pressed(ord("R")) {
	if global.is_browser = 1 {
		changeQuery("loadBoard","","loadSecret","")
	}
	room_restart()	
}

//if keyboard_check_released(ord("R")) {
	
//	scr_board_init()
//}

if keyboard_check_pressed(vk_space) {
	//useParentQueryString()
}

if global.show_input_prompt >= 1 || global.show_export_prompt >= 1 || global.show_archives >= 1 {
	global.show_any_menu = 1
} else {
	global.show_any_menu = 0
}

global.show_any_menu_fd = lerp(global.show_any_menu_fd,global.show_any_menu,0.1)

if global.is_browser = 0 {
	if keyboard_check_pressed(vk_escape) {
		if global.show_any_menu >= 1 {
			html_submit_closebtn()
		}
	}
}

if mouse_check_button_pressed(mb_left) {
	
	
	if device_mouse_y_to_gui(0)*global.pr < 50*global.pr && device_mouse_x_to_gui(0)*global.pr < display_get_gui_width()*0.3 {
		
		if global.is_browser = 1 {
			changeQuery("loadBoard","","loadSecret","")
			reloadPage()
		} else {
			room_restart()	
		}
	}
	
	if global.game_phase = 0 {
		
		
		if global.show_any_menu = 0  {
			
			
			if device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.3 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.5 {
				
				
				if device_mouse_x_to_gui(0)*global.pr < display_get_gui_width()*0.3 {
					//load daily
					
					//global.loadBoard = "EXITBTSNOSEIDAHA"
					//global.loadSecret = "1-2-6-11-8-4"
					
					global.loadBoard = "IYEIORAOABEANEAEPCINMALNI"
					global.loadSecret = "17-23-22-18-14-10-5"
					
					//https://fermentergames.github.io/sneakle/?loadBoard=DARKNESSHELLFIRE&loadSecret=8-11-10-5-1-6-3
					
					global.loadBoard = "DARKNESSHELLFIRE"
					global.loadSecret = "8-11-10-5-1-6-3"
					
					var _event_struct = { //
				      screen_name: "DailyFromMainMenu",
				   };
					GoogHit("screen_view",_event_struct)
					
					
					
					scr_board_init()
					
					
				} else if device_mouse_x_to_gui(0)*global.pr > display_get_gui_width()*0.3 && device_mouse_x_to_gui(0)*global.pr < display_get_gui_width()*0.7 {
					//load
					//var _event_struct = { //
				   //   screen_name: "LoadFromMainMenu",
				   //};
					//GoogHit("screen_view",_event_struct)
					//global.show_input_prompt = 1
					global.show_archives = 1
					
					alarm[0] = 2
					
					//generatePuzzleList()
					//addClassElemID("puzzleMenuWrapper","show")
				
				} else {
					//
				}
			
			} else if scr_mouse_over_button(global.sw*0.2,global.sh*0.6,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 3
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Create3",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.35,global.sh*0.6,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 4
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Create4",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.5,global.sh*0.6,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 5
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Create5",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.65,global.sh*0.6,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 6
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Create6",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.8,global.sh*0.6,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 7
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Create7",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
			
				////////////////////////////////////////
			
			} else if scr_mouse_over_button(global.sw*0.2,global.sh*0.7,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 3
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Random3",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.35,global.sh*0.7,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 4
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Random4",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.5,global.sh*0.7,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 5
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 0
				global.skip_create = 1
				
				global.am_generate_random = 1
				
				//global.loadBoard = "IYEIORAOABEANEAEPCINMALNI"
				//global.loadBoard = "XXXXXXXXXXXXXXXXXXXXXXXXX"
				
				var _event_struct = { //
				   screen_name: "Random5",
				};
				GoogHit("screen_view",_event_struct)
				
				
				
				
				scr_board_init()
				
				
			} else if scr_mouse_over_button(global.sw*0.65,global.sh*0.7,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 6
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Random6",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			} else if scr_mouse_over_button(global.sw*0.8,global.sh*0.7,0.12*_tscl,0.12*_tscl) { //device_mouse_y_to_gui(0)*global.pr > display_get_gui_height()*0.5 && device_mouse_y_to_gui(0)*global.pr < display_get_gui_height()*0.7 {
				
				global.game_grid_size = 7
				global.game_grid_size_sqr = sqr(global.game_grid_size)
				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "Random7",
				};
				GoogHit("screen_view",_event_struct)
				scr_board_init()
				
			}

		
				
		
			
			
		}
		
		
	}
	
	
	if global.game_phase = 1 {
		
		if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			if point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw/2)-(256*0.65*_tscl),(global.sh+(-150*global.pr))-(256*0.14*_tscl),(global.sw/2)+(256*0.65*_tscl),(global.sh+(-150*global.pr))+(256*0.14*_tscl)) {
			//if device_mouse_y_to_gui(0)*global.pr > global.sh-100*global.pr && !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			
				//auto fill

				if _empty_tile_count >= 0 { //there are some empty spaces
		
					_empty_tile = array_shuffle(_empty_tile)
	
					_empty_tile_count = 0 //reset
					for (var i = 1; i <= global.game_grid_size_sqr; ++i) {

						if global.tile_letter[i].am_set = 0 {

							//_empty_letter[i] = global.tile_space[i]
					
							with (global.tile_letter[i]) {
				
								//show_debug_message(object_get_name(_empty_tile[i].object_index))
					
								targ_id = _empty_tile[_empty_tile_count].id
								_empty_tile_count += 1
								x_targ = targ_id.x
								y_targ = targ_id.y
								am_set = 1
								prev_targ_id = targ_id
								am_set_flash = 1
							}
						}
					}
	
				} else {
				
					//confirm grid, proceed to setting secret
					for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
						with (global.tile_letter[i]) {
							if am_set >= 1 {
								if instance_exists(targ_id) && targ_id != -1 {
				
									//show_debug_message(object_get_name(_empty_tile[i].object_index))
					
									tile_id = targ_id.tile_id
								
									global.letters_grid[tile_id] = my_letter_str
						
								}
							}
						}
					}
			
				
					global.game_phase = 2	
					dragging = 0
					selected_word_length = 0
					selected_word_not_in_dictionary = 0
					selected_word_is_valid = 0
					selected_word_str = ""
					selected_word_array = 0
					selected_word_array_id = 0
					ready_for_phase3 = 0
					
			
				}
			} else if global.game_mode = 1 && point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.3)-(256*0.3*_tscl),(global.sh+(-70*global.pr))-(256*0.08*_tscl),(global.sw*0.3)+(256*0.3*_tscl),(global.sh+(-70*global.pr))+(256*0.08*_tscl)) {
				
				show_debug_message("NEW LETTERS")
				
				with (obj_tile_letter) {
					instance_destroy()
				}
				with (obj_tile_space) {
					instance_destroy()
				}

				global.am_creating = 1
				var _event_struct = { //
				   screen_name: "NewLetters"+string(global.game_grid_size),
				};
				GoogHit("screen_view",_event_struct)
				
				global.loadSecret = ""
				global.loadBoard = ""
				global.current_copy_code = ""
				global.current_copy_link = ""
				scr_update_copy_code()
				
				scr_board_init()
				
				
				
				with (obj_tile_letter) {
					//instance_destroy()
					image_angle = 0
					born_fd = 1
					spawn_slam = 0
					am_set = 1
					am_set_fd = 1
					am_set_flash = 0
					x = x_targ
					y = y_targ
				}
				
			} else if global.game_mode = 1 && point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.7)-(256*0.3*_tscl),(global.sh+(-70*global.pr))-(256*0.08*_tscl),(global.sw*0.7)+(256*0.3*_tscl),(global.sh+(-70*global.pr))+(256*0.08*_tscl)) {
				show_debug_message("TYPE LETTERS")
				
				var _event_struct = { //
				   screen_name: "LoadFromCreate",
				};
				GoogHit("screen_view",_event_struct)
				global.show_input_prompt = 1
				
			} else if point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.5)-(256*0.3*_tscl),(global.sh+(-10*global.pr))-(256*0.08*_tscl),(global.sw*0.5)+(256*0.3*_tscl),(global.sh+(-10*global.pr))+(256*0.08*_tscl)) {
				
				
				
				if global.game_mode = 1 {
					
					global.game_mode = 2	
					
					//reset
					global.points_total = 0
					global.words_made = 0
					global.rearranges_used = 0
					global.discards_used = 0
					
				} else {
					global.game_mode = 1
				}
				
				
				
			}
			
			
		}
		
	} else if global.game_phase = 2 { //
		
		//proceed
		if point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.5)-(256*0.65*_tscl),(global.sh+(-110*global.pr))-(256*0.15*_tscl),(global.sw*0.5)+(256*0.65*_tscl),(global.sh+(-110*global.pr))+(256*0.15*_tscl)) {
			
			
			if global.game_mode = 1 && selected_word_is_valid >= 1 {
				//proceed, lock in word
				
				secret_word_length = selected_word_length
				secret_word_str = selected_word_str
				secret_word_array = selected_word_array
				secret_word_array_id = selected_word_array_id
				guesses_count = 0
				
				selected_word_length = 0
				selected_word_str = ""
				selected_word_array = 0
				
				with (obj_tile_letter) {
					am_exed = 0
					am_clued = 0	
				}
				
				
				
				//assign all tiles to corresponding space
				//for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
					with (obj_tile_letter) {
						tile_id = targ_id.tile_id
						global.letters_grid[tile_id] = my_letter_str
						global.tile_letter[tile_id] = id
					}
				//}
				
				
				
				var _letters_str = ""
				for (var l = 0; l < secret_word_length; ++l) {
					_letters_str += global.letters_grid[secret_word_array[l]]
				}
			
			
				
				show_debug_message("SECRET WORD CHOSEN: "+string(_letters_str))
				
				scr_update_copy_code()
				
				var _event_struct = { //
					screen_name: "CREATE_"+string(global.game_grid_size)+"_"+string(global.current_copy_code),
				};
				GoogHit("screen_view",_event_struct)
				
				global.show_export_prompt = 1
				
				global.game_phase = 3
				just_phase_changed = 1
			
			}
			
			if global.game_mode = 2 && selected_word_is_valid >= 1 {
				
				//secret_word_length = selected_word_length
				//secret_word_str = selected_word_str
				//secret_word_array = selected_word_array
				//secret_word_array_id = selected_word_array_id
				//guesses_count = 0
				
				var _letters_str = ""
				for (var l = 0; l < selected_word_length; ++l) {
					_letters_str += global.letters_grid[selected_word_array[l]]
				}
				
				show_debug_message("SCORING WORD CHOSEN: "+string(_letters_str))
				//global.points_total = 0
				global.points_total += obj_ctrl.selected_word_base_points*obj_ctrl.selected_word_length
				show_debug_message("ADD SCORE "+string(obj_ctrl.selected_word_base_points*obj_ctrl.selected_word_length))
				show_debug_message("TOTAL SCORE NOW: "+string(global.points_total))
				
				global.words_made += 1
				show_debug_message("words_made: "+string(global.words_made))
				
				selected_word_length = 0
				selected_word_str = ""
				selected_word_array = 0
				selected_word_array_id = 0
				
				
				
				
				
				
				
				with (obj_tile_letter) {
					if am_part_of_secret_word = 1 { //replace only selected word
						
						with (instance_create_depth(x,y,depth,obj_tile_letter)) {
							tile_id = other.tile_id
							tile_col = other.tile_col
							tile_row = other.tile_row
							targ_id = other.targ_id
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
						
						//now destroy the original one
						instance_destroy()
					}
				}
				
				//assign all tiles to corresponding space
				with (obj_tile_letter) {	
					tile_id = targ_id.tile_id
					global.letters_grid[tile_id] = my_letter_str
					global.tile_letter[tile_id] = id
				}

				scr_update_copy_code()
				
				selected_word_is_valid = 0//reset
				
			
			}
		}
		
		//back
		if point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.15)-(256*0.2*_tscl),(global.sh+(-30*global.pr))-(256*0.08*_tscl),(global.sw*0.15)+(256*0.2*_tscl),(global.sh+(-30*global.pr))+(256*0.08*_tscl)) {
			global.game_phase = 1
			selected_word_length = 0
			selected_word_str = ""	
			with (obj_tile_letter) {
				am_part_of_secret_word = 0	
			}
		}
		

		
	} else if global.game_phase = 3 { //
		
		//back
		if point_in_rectangle(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,(global.sw*0.15)-(256*0.2*_tscl),(global.sh+(-30*global.pr))-(256*0.08*_tscl),(global.sw*0.15)+(256*0.2*_tscl),(global.sh+(-30*global.pr))+(256*0.08*_tscl)) {
		
			global.game_phase = 2
			with (obj_tile_letter) {
				am_exed = 0
				am_clued = 0
				//am_part_of_secret_word = 0	
			}
				
			selected_word_length = secret_word_length
			selected_word_str    = secret_word_str
			selected_word_array	= secret_word_array
			selected_word_array_id	= secret_word_array_id
	
		}
		
	}
	
	if global.game_phase >= 3 {
		//share
		if device_mouse_y_to_gui(0)*global.pr < 50*global.pr && !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			if device_mouse_x_to_gui(0)*global.pr > display_get_gui_width()*0.7 {
				global.show_export_prompt = 1	

				var _event_struct = { //
				   content_type: "SharePuzzleLink",
				};
				GoogHit("share",_event_struct)
			}
		}
	}


}



var _too_far_trigger_release = 0
if selecting >= 1 {
	//var _nearest_tile = instance_nearest(mouse_x,mouse_y,obj_tile_letter)
	//if point_distance(_nearest_tile.x,_nearest_tile.y,mouse_x,mouse_y) > 80 {
	
	if instance_exists(selected_word_latest_tile_id) && selected_word_latest_tile_id != -1 {
		
		//show_debug_message(point_distance(selected_word_latest_tile_id.x,selected_word_latest_tile_id.y,mouse_x,mouse_y))
		
		if point_distance(selected_word_latest_tile_id.x,selected_word_latest_tile_id.y,mouse_x,mouse_y) > 110 {
	
			show_debug_message("dragged too far!")
		
			
			_too_far_trigger_release = 1
			
		}
	}
}


if mouse_check_button_released(mb_left) || _too_far_trigger_release = 1 {
	
	if (global.game_phase = 2 || global.game_phase = 3) && just_phase_changed <= 0  {
		if selecting >= 1 {
		
		
			var _valid_guess = 1
			
			
			_valid_guess = scr_validate_word()
			
			show_debug_message(selected_word_array)
			
			if _valid_guess = 1 {
				

				if global.game_phase = 3 {
			
					var _valid_guess = 1
			
					if selected_word_length <= 3 {
						_valid_guess = 0
					}
			
					if _valid_guess = 1 {
						guesses_count += 1
						show_debug_message("guesses_count: "+string(guesses_count))
						
						guesses_list[guesses_count] = string(selected_word_str)
			
						show_debug_message(selected_word_str)
						show_debug_message(secret_word_str)
			
						if selected_word_str = secret_word_str {
							show_debug_message("match!")
							global.game_phase = 4

							
							var _event_struct = { //
							   level: guesses_count,
							};
							GoogHit("post_score",_event_struct)
				
							with (obj_tile_letter) {
								if 1 = 1 {
									for (var l = 0; l < obj_ctrl.secret_word_length; ++l) {
										if obj_ctrl.secret_word_array[l] = tile_id {
											am_clued = 1
											am_clued_flash = 1
											am_clued_won = 1
											am_exed = 0
										}
									}
						
									if am_clued = 0 {
										//am_exed = 1 //ex all
										am_samelettered = 0
									}
						
								}
							}
				
						} else if selected_word_str != secret_word_str {
							show_debug_message("no match!")
				
							with (obj_tile_letter) {
								if am_selected = 1 {
									for (var l = 0; l < obj_ctrl.secret_word_length; ++l) {
										if obj_ctrl.secret_word_array[l] = tile_id {
											//
										} else {
											am_exed = 1	
								
											if global.letters_bag[obj_ctrl.secret_word_array[l]] = my_letter_str {
												am_samelettered = 1
											}
								
										}
									}
						
									for (var l = 0; l < obj_ctrl.secret_word_length; ++l) {
										if obj_ctrl.secret_word_array[l] = tile_id {
											if am_clued <= 0 {
												am_clued = 1
												am_clued_flash = 1
											}
											am_exed = 0
										}
									}
								}
							}
				
						}
					} else {
						show_debug_message("invalid guess: "+string(selected_word_str))	
					}
				}
			
			}
		
	
			selecting = 0
			selected_word_latest_tile = -1
			selected_word_latest_tile_id = -1
	
			with (obj_tile_letter) {
				if am_selected >= 1 {
					am_selected = 0
					am_selected_start = 0
					am_selected_end = 0
					am_selected_num = 0
					if global.game_phase = 2 && _valid_guess = 1 {
						am_part_of_secret_word = 1
					}
				}	
			}
	
		}
	}
	
}

if just_phase_changed > 0 {
	just_phase_changed -= 0.05	
}



ready_for_phase2_fd = lerp(ready_for_phase2_fd,ready_for_phase2,0.1)

if global.game_phase < 2 && ready_for_phase2_fd <= 0.5 {
	global.am_creating_fd = lerp(global.am_creating_fd,1,0.1)	
} else {
	global.am_creating_fd = lerp(global.am_creating_fd,0,0.2)	
}



if global.game_phase < 2 {
	global.am_creating_fd2 = lerp(global.am_creating_fd2,1,0.1)	
} else {
	global.am_creating_fd2 = lerp(global.am_creating_fd2,0,0.2)	
}

dragging_fd = lerp(dragging_fd,dragging,0.2)


if browser_width != curr_width || browser_height != curr_height {//|| 1=1 { //1=1 || 
	
	curr_width = browser_width
	curr_height = browser_height

	event_user(0);
	
}

var w = browser_width;
var h = browser_height;
var _tile_sz_and_pad = global.tile_size+global.pad_size
//global.cam_zoom = (((_tile_sz_and_pad*global.game_grid_size)+100)/w)*1.5
//global.cam_zoom_fd = lerp(global.cam_zoom_fd,global.cam_zoom+(-0.35*(1-global.am_creating_fd)),0.05)

global.cam_zoom = (((_tile_sz_and_pad*global.game_grid_size)+(w*0.1))/w)*1.7

if global.sw >= global.sh*0.65 {
	global.is_landscape = 1
	global.cam_zoom = (((_tile_sz_and_pad*global.game_grid_size)+(h*0.1))/h)*2.8
}
global.cam_zoom_fd = lerp(global.cam_zoom_fd,global.cam_zoom+(-0.35*(1-global.am_creating_fd)),0.05)

//scr_update_room_dimensions(w*global.cam_zoom,h*global.cam_zoom)
camera_set_view_size(view_camera[0], w*global.cam_zoom_fd, h*global.cam_zoom_fd);
//center cam
//camera_set_view_pos(view_camera[0],-(w*global.cam_zoom_fd/2),(-h*global.cam_zoom_fd*0.5)+(100*global.cam_zoom_fd*(1-global.am_creating_fd)))
camera_set_view_pos(view_camera[0],-(w*global.cam_zoom_fd/2),(-h*global.cam_zoom_fd*0.0)+(-_tile_sz_and_pad*global.game_grid_size*0.5)+(-110*global.cam_zoom_fd))                                                                

