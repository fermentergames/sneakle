///
function scr_board_init() {
if (live_call()) return live_result;

	//curr_width = browser_width
	//curr_height = browser_height
	
	show_debug_message("scr_board_init")

	


	


	/*
	tile_distribution = {
			'A': 13, 'B': 3, 'C': 3, 'D': 6, 'E': 18, 'F': 3, 'G': 4, 'H': 3, 'I': 12, 
			'J': 2, 'K': 2, 'L': 5, 'M': 3, 'N': 8, 'O': 11, 'P': 3, 'Q': 2, 'R': 9, 
			'S': 6, 'T': 9, 'U': 6, 'V': 3, 'W': 3, 'X': 2, 'Y': 3, 'Z': 2
	}
	*/
	
	global.letters_grid = 0//reset
	
	
	if global.loadBoard = "" {
				
		global.letter_set_default = "AAAAAAAAAAAAABBBCCCDDDDDDEEEEEEEEEEEEEEEEEEFFFGGGGHHHIIIIIIIIIIIIJJKKLLLLLMMMNNNNNNNNOOOOOOOOOOOPPPQQRRRRRRRRRSSSSSSTTTTTTTTTUUUUUUVVVWWWXXYYYZZ"
	
		//global.letter_set_default = "AAAAQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	
	
		for (var l = 0; l <= string_length(global.letter_set_default)-1; ++l) {
			global.letters_bag[l] = string_char_at(global.letter_set_default,l)
			//show_debug_message(global.letters_bag[l])
		}
				
		//global.letters_bag[0] = "R"	//to avoid undefined in array	
				
		global.letters_bag = array_shuffle(global.letters_bag)
		//show_debug_message("/////////////")
		//show_debug_message("//SHUFFLING//")
		//show_debug_message("/////////////")
		
		global.skip_create = 1 //0
		
		if global.am_creating = 1 {
			global.game_phase = 1
		} else {
			global.game_phase = 3	
		}
				
		//for (var l = 0; l <= string_length(global.letter_set_default)-1; ++l) {
			//show_debug_message(global.letters_bag[l])
		//}
		
		show_debug_message(global.letters_bag)
		
		var _grid_sz = global.game_grid_size
	
	
		if 1=1 { //ensure Q has U
			
			//show_debug_message("DO THE Q CHECK!")

			var _letters_have_Q = 0
			var _letters_have_U = 0
			
			for (var i = 1; i <= sqr(_grid_sz); ++i) {
				
				//show_debug_message("checking letters["+string(i))
				
				if global.letters_bag[i] = "U" {
					_letters_have_U = i
				} else if global.letters_bag[i] = "Q" {
					_letters_have_Q = i
					//show_debug_message("Q on board! "+string(i))
				}
			
			}
	
			if _letters_have_Q >= 1 && _letters_have_U <= 0 {
		
				//show_debug_message("Q on board without U!")
		
				if _letters_have_Q < sqr(_grid_sz) {
					global.letters_bag[_letters_have_Q+1] = "U"
				} else { //Q is last letter in set
					global.letters_bag[_letters_have_Q-1] = "U"
				}
		
			}
	
		}
		
	
	} else { //not default
		
		
	
		global.letter_set = global.loadBoard
		for (var l = 1; l <= string_length(global.letter_set); ++l) {
			global.letters_bag[l] = string_char_at(global.letter_set,l)
			//show_debug_message(global.letters_bag[l])
		}
		
		global.skip_create = 1
	
		//global.letters_bag = array_shuffle(global.letters_bag)
		
		global.game_grid_size = floor(sqrt(string_length(global.letter_set)))
		global.game_grid_size_sqr = string_length(global.letter_set)
	
	}
	
	with (obj_ctrl) {
		event_user(0);
	}
	
	global.cam_zoom_fd = global.cam_zoom+(-0.35*(1-global.am_creating_fd))
	
	show_debug_message("zoom is: "+string(global.cam_zoom))
	
	show_debug_message("global.game_grid_size:")
	show_debug_message(global.game_grid_size)
	
	var _grid_sz = global.game_grid_size
	var _tile_sz = global.tile_size
	var _tile_pad = global.pad_size
	var _grid_dim = global.game_grid_size*36///global.cam_zoom
	var _grid_pad = 50
	
	//global.grid_x_origin = (room_width/2) 
	global.grid_x_origin = 0
	//global.grid_y_origin = (room_height/2)-170 
	global.grid_y_origin = 0
	var _grid_x = global.grid_x_origin
	var _grid_y = global.grid_y_origin
				
	
	
	
	//_grid_y -= _grid_dim+(_grid_pad*0.5)
	
	
	for (var i = 1; i <= _grid_sz; ++i) {
	   for (var o = 1; o <= _grid_sz; ++o) {
			with (instance_create_layer(_grid_x+((_tile_sz+_tile_pad)*(-0.5+(-_grid_sz/2)))+((_tile_sz+_tile_pad)*i),_grid_y+((_tile_sz+_tile_pad)*(-0.5+(-_grid_sz/2)))+((_tile_sz+_tile_pad)*o),layer_get_id("lyr_1"),obj_tile_space)) {
				tile_id = (i)+((o-1)*global.game_grid_size)
				tile_col = i
				tile_row = o
				global.tile_space[tile_id] = id
			}
		} 
	}
	
	if global.skip_create = 0 {
		_grid_y += (_grid_dim+(_grid_pad*0.5))*2
	}
	
	var _tile_pad_mult = 6/global.game_grid_size
	
	
	for (var i = 1; i <= _grid_sz; ++i) {
	   for (var o = 1; o <= _grid_sz; ++o) {
			with (instance_create_layer(_grid_x+((_tile_sz+_tile_pad*_tile_pad_mult)*(-0.5+(-_grid_sz/2)))+((_tile_sz+_tile_pad*_tile_pad_mult)*i)+(-10+random(20)),_grid_y+((_tile_sz+_tile_pad*_tile_pad_mult)*(-0.5+(-_grid_sz/2)))+((_tile_sz+_tile_pad*_tile_pad_mult)*o)+(-10+random(20)),layer_get_id("lyr_2"),obj_tile_letter)) {
			//with (instance_create_layer(_grid_x+(-20+random(40)),_grid_y+(-20+random(40)),layer_get_id("lyr_2"),obj_tile_letter)) {
				tile_id = (i)+((o-1)*global.game_grid_size)
				tile_col = i
				tile_row = o
				global.tile_letter[tile_id] = id
				
				
				spawn_slam = 2+(-0.5*tile_col*(1/global.game_grid_size))+(-0.5*tile_row*(1/global.game_grid_size))
				
				image_angle = (-20+random(40))
				
				if global.loadBoard != "" {
					my_letter_str = string_upper(global.letters_bag[tile_id])
				} else {
					//take first array entry
					my_letter_str = array_shift(global.letters_bag)
					//replace letters array end
					array_push(global.letters_bag,my_letter_str)
				}
				
				
				for (var l = 1; l <= array_length(global.letter_data); ++l) {
					show_debug_message(string(l)+": "+string(my_letter_str))
				   if my_letter_str = global.letter_data[l,1] {
						my_letter_num = l
						l = array_length(global.letter_data)
					}
				}
				
			}
		} 
	}
	
	
	if global.skip_create = 1 {
		
		global.am_creating_fd = 0 //skip the zoom
		
		//assign all tiles to corresponding space
		for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
			with (global.tile_letter[i]) {
				
				//show_debug_message(object_get_name(_empty_tile[i].object_index))
					
				targ_id = global.tile_space[tile_id]
				
				x_targ = targ_id.x
				y_targ = targ_id.y
				am_set = 1
				prev_targ_id = targ_id
				am_set_flash = 1
				
				global.letters_grid[i] = my_letter_str
				
			}
		}
		
		
		if global.am_generate_random = 1 {
			
			scr_generate_pick_word()
			
			scr_generate_board_setup()
			
		} else if global.am_creating = 1 {
			
			//keep defaults
			scr_update_copy_code()
			
		} else {
			if global.loadSecret = "" {
			
				//ok need to set secret
				selected_word_length = 0
				selected_word_str = ""
				selected_word_array = 0
				global.game_phase = 1
				scr_update_copy_code()
			
			} else {
			
			
				show_debug_message("global.loadSecret = "+string(global.loadSecret))
			
				secret_word_array = 0 //reset
				secret_word_array_id = 0 //reset
				secret_word_array = string_split(global.loadSecret,"-",true)
				show_debug_message("secret_word_array = "+string(secret_word_array))
			
			
				for (var i = 0; i < array_length(secret_word_array); ++i) {
				   secret_word_array[i] = real(secret_word_array[i])
				
					with (obj_tile_letter) {
						if tile_id = other.secret_word_array[i] {
							other.secret_word_array_id[i] = id
							other.secret_word_str += string(my_letter_str)
							
							am_part_of_secret_word_order = i
						}
					}
				}
			
				secret_word_length = array_length(secret_word_array)

				//proceed, lock in word
				
				//secret_word_length = selected_word_length
				//secret_word_str = selected_word_str
				//secret_word_array = selected_word_array
				//secret_word_array_id = selected_word_array_id
				guesses_count = 0
				
				selected_word_length = 0
				selected_word_str = ""
				selected_word_array = 0
				
				with (obj_tile_letter) {
					am_exed = 0
					am_clued = 0	
				}
				
				var _letters_str = ""
				for (var l = 0; l < secret_word_length; ++l) {
					_letters_str += global.letters_grid[secret_word_array[l]]
				}
				
				show_debug_message("SECRET WORD SET FROM LOAD: "+string(_letters_str))
			
			
				scr_update_copy_code()
			
				var _event_struct = { //
					screen_name: "LOAD_"+string(global.game_grid_size)+"_"+string(global.current_copy_code),
				};
				GoogHit("screen_view",_event_struct)
			
				
				global.game_phase = 3
				just_phase_changed = 1
		
			}
		}
		
	}
	
}