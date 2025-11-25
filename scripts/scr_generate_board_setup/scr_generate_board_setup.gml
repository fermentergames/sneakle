///
function scr_generate_board_setup(){
if (live_call()) return live_result;

	var _grid_sz = global.game_grid_size
	
	//reset board to "X"
	for (var i = 0; i < _grid_sz; ++i) {
	   for (var o = 0; o < _grid_sz; ++o) {
			with (global.tile_letter[1+(o)+((i)*_grid_sz)]) {
				my_letter_str = "-"
			}
		}
	}
	
	
	
	var _generated_word_length = string_length(global.generated_word)

	var _generated_arr_pattern = [ 21,22,23,17,16,11,12,13,18,24,19,14,8,9,5,10,4,3,2,7,1,6 ]
	var _generated_arr_pattern_offset = irandom(array_length(_generated_arr_pattern)-_generated_word_length)
	var _generated_arr = [0]
	
	
	
	//var _generated_arr = 
	
	for (var i = 0; i < _generated_word_length; ++i) { //_generated_word_length
		_generated_arr[i] = _generated_arr_pattern[i+_generated_arr_pattern_offset]
	}
	
	//global.generated_word = "ABCDEFGHIJKLMNOPQRSTUVWXY"
	
	//global.generated_word = "123456789123456789123456789"
	
	//var _generated_arr = [ 1,6,11,16,21,22,23]
	
	show_debug_message(_generated_arr)
	show_debug_message(array_length(_generated_arr))
	
	
	var _generated_arr_2d = -1
	
	
	
	for (var i = 0; i < _grid_sz; ++i) { //cols
	   for (var o = 0; o < _grid_sz; ++o) { //rows
			_generated_arr_2d[0][(i)+((o)*_grid_sz)] = i //col
			_generated_arr_2d[1][(i)+((o)*_grid_sz)] = o //row
			_generated_arr_2d[2][(i)+((o)*_grid_sz)] = (i)+((o)*_grid_sz)+1
			
			_generated_arr_2d[3][(i)+((o)*_grid_sz)] = -1
			for (var p = 0; p < array_length(_generated_arr); ++p) {
				if _generated_arr_2d[2][(i)+((o)*_grid_sz)] = _generated_arr[p] {
					//show_debug_message("p:"+string(p)+" = id:"+string(_generated_arr_2d[2][(i)+((o)*_grid_sz)]))
					_generated_arr_2d[3][(i)+((o)*_grid_sz)]	= p+1
				}
			}
			
			
		}
	}
	
	show_debug_message(_generated_arr_2d)
	
	
	var _generate_do_transformation = 0
	
	_generate_do_transformation = choose(0,1,2,3,4)
	
	
	if _generate_do_transformation = 1 { //reverse / rotate 180
	
		var rows = array_length(_generated_arr_2d[3]);

		show_debug_message(rows)
	
	   var mirrored_array = array_create(rows);

	   for (var i = 0; i < rows; i++) {
	      mirrored_array[i] = _generated_arr_2d[3][rows - 1 - i];
	   }
	   //return mirrored_array;
		show_debug_message(mirrored_array)
	
		_generated_arr_2d[3] = mirrored_array
	
		show_debug_message("GENERATE TRANSFORM: 180 clockwise")
		show_debug_message(_generated_arr_2d)
	
	}
	
	if _generate_do_transformation = 2 { //rotate 90 clockwise

	   var test_arr_cols = array_create(array_length(_generated_arr_2d[3])/_grid_sz);
		
		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows
				test_arr_cols[i][o] = _generated_arr_2d[3][(i)+((o)*_grid_sz)]
			}
		}
		
		for (var i = 0; i < _grid_sz; ++i) { //cols
			test_arr_cols[i] = array_reverse(test_arr_cols[i])
		}
		
		show_debug_message(test_arr_cols)

		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows	
				_generated_arr_2d[3][(i)+((o)*_grid_sz)] = test_arr_cols[o][i]
			}
		}

		show_debug_message("GENERATE TRANSFORM: 90 clockwise")
		show_debug_message(_generated_arr_2d)
	
	}
	
	if _generate_do_transformation = 3 { //mirror horizontal
	
	   var test_arr_rows = array_create(array_length(_generated_arr_2d[3])/_grid_sz);
		
		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows
				test_arr_rows[o][i] = _generated_arr_2d[3][(i)+((o)*_grid_sz)]
			}
		}
		
		for (var o = 0; o < _grid_sz; ++o) { //rows
			test_arr_rows[o] = array_reverse(test_arr_rows[o])
		}
		
		show_debug_message(test_arr_rows)

		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows	
				_generated_arr_2d[3][(i)+((o)*_grid_sz)] = test_arr_rows[o][i]
			}
		}

		show_debug_message("GENERATE TRANSFORM: mirror horizontal")
		show_debug_message(_generated_arr_2d)
	
	}
	
	if _generate_do_transformation = 4 { //mirror vertical

	   var test_arr_cols = array_create(array_length(_generated_arr_2d[3])/_grid_sz);
		
		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows
				test_arr_cols[i][o] = _generated_arr_2d[3][(i)+((o)*_grid_sz)]
			}
		}
		
		for (var i = 0; i < _grid_sz; ++i) { //cols
			test_arr_cols[i] = array_reverse(test_arr_cols[i])
		}
		
		show_debug_message(test_arr_cols)

		for (var i = 0; i < _grid_sz; ++i) { //cols
		   for (var o = 0; o < _grid_sz; ++o) { //rows	
				_generated_arr_2d[3][(i)+((o)*_grid_sz)] = test_arr_cols[i][o]
			}
		}

		show_debug_message("GENERATE TRANSFORM: mirror vertical")
		show_debug_message(_generated_arr_2d)
	
	}
	




	//
	
	show_debug_message("INSERT GENERATED WORD INTO GRID")
	
	secret_word_length = 0
	secret_word_str = ""
	secret_word_array = 0
	secret_word_array_id = 0
	
	for (var i = 0; i < _grid_sz; ++i) {
	   for (var o = 0; o < _grid_sz; ++o) {
			with (global.tile_letter[1+(o)+((i)*_grid_sz)]) {
				//show_debug_message(tile_id)
				
				if _generated_arr_2d[3][(o)+((i)*_grid_sz)] != -1 {
					//show_debug_message("MATCH")
					//my_letter_str = string(_generated_arr_2d[3][(o)+((i)*_grid_sz)]) //string_char_at(global.generated_word,tile_id)
					my_letter_str = string_char_at(global.generated_word,_generated_arr_2d[3][(o)+((i)*_grid_sz)])
					//show_debug_message(my_letter_str)
					
					obj_ctrl.secret_word_array_id[(_generated_arr_2d[3][(o)+((i)*_grid_sz)])-1] = id
					obj_ctrl.secret_word_array[(_generated_arr_2d[3][(o)+((i)*_grid_sz)])-1] = (o)+((i)*_grid_sz)+1
					
					//spawn_slam = 2+(-0.5*tile_col*(1/global.game_grid_size))+(-0.5*tile_row*(1/global.game_grid_size))
					//image_angle = (-20+random(40))	
					
				}
			}
		}
	}
	
	show_debug_message("secret_word_array:")
	show_debug_message(obj_ctrl.secret_word_array)

	
	//replace "-"s with random letters
	with (obj_tile_letter) {
		if my_letter_str = "-" { //replace only "-"s
						
			with (instance_create_depth(x,y,depth,obj_tile_letter)) {
				tile_id = other.tile_id
				tile_col = other.tile_col
				tile_row = other.tile_row
				targ_id = other.targ_id
				global.tile_letter[tile_id] = id
							

				//spawn_slam = 2+(-0.5*tile_col*(1/global.game_grid_size))+(-0.5*tile_row*(1/global.game_grid_size))
				//image_angle = (-20+random(40))		
				
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
		
		x_targ = targ_id.x
		y_targ = targ_id.y
		am_set = 1
		prev_targ_id = targ_id
		am_set_flash = 1
		
	}
	
	
	
	
	
	var _letters_str = ""
	secret_word_str = ""
	
	secret_word_length = array_length(secret_word_array)
	
	for (var l = 0; l < secret_word_length; ++l) {
		_letters_str += global.letters_grid[secret_word_array[l]]
		secret_word_str += global.letters_grid[secret_word_array[l]]
	}
			
			
				
	show_debug_message("SECRET WORD CHOSEN: "+string(_letters_str))
	

	scr_update_copy_code()	
	


}