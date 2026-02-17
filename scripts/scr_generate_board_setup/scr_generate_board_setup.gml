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

	var _generated_arr_pattern_3_1 = [ 1,2,3,5,6,9,8,4,7]
	var _generated_arr_pattern_3_2 = [ 6,9,5,3,2,1,4,8,7 ]
	var _generated_arr_pattern_3_3 = [ 4,1,2,5,7,8,9,6,3 ]
	
	var _generated_arr_pattern_4_1 = [ 9,13,10,14,15,16,12,7,11,6,1,5,2,3,8,4 ]
	var _generated_arr_pattern_4_2 = [ 7,12,16,11,8,4,3,2,6,1,5,9,13,10,15,14 ]
	var _generated_arr_pattern_4_3 = [ 1,2,3,6,10,13,14,15,16,11,8,4,7 ]
	
	var _generated_arr_pattern_5_1 = [ 21,22,23,17,16,11,12,13,18,24,19,14,8,9,5,10,4,3,2,7,1,6 ]
	var _generated_arr_pattern_5_2 = [ 12,18,23,24,25,20,19,15,10,5,9,13,14,8,4,3,2,7,1,6,11,17,16,22,21 ]
	var _generated_arr_pattern_5_3 = [ 1,2,3,4,9,13,12,17,21,22,23,24,20,15,14,8,7,11,16 ]
	
	var _generated_arr_pattern_6_1 = [ 20,26,27,33,32,25,19,13,14,15,22,28,34,35,36,30,29,24,18,23,17,12,6,5,10,9,8,1,7,2,3,4,11,16,21 ]
	var _generated_arr_pattern_6_2 = [ 5,6,11,10,16,17,12,18,24,30,23,29,34,33,26,32,25,19,13,14,7,8,2,3,4,9,15,20,21,22,27,28,35,36 ]
	var _generated_arr_pattern_6_3 = [ 9,14,20,26,33,34,29,22,23,17,11,6,5,4,3,8,15,21,16,10 ]
	var _generated_arr_pattern_6_4 = [ 4,3,2,7,13,20,27,22,23,17,18,24,30,35,34,33,26,21,15,9,10,5,6 ]
	
	var _generated_arr_pattern_7_1 = [ 17,25,24,30,23,16,15,9,10,18,26,32,40,48,49,41,42,35,28,21,20,12,13,14,7,6,5,4,3,11,19,27,34,33,39,47,46,45,38,31,37,44,36,29,22 ]
	var _generated_arr_pattern_7_2 = [ 21,20,19,13,7,6,12,18,24,25,17,11,4,10,16,9,8,15,22,23,31,30,37,29,36,44,38,32,33,40,39,46,47,41,34,28,35,27,26 ]
	var _generated_arr_pattern_7_3 = [ 5,6,7,14,21,27,34,40,32,25,26,19,11,10,16,23,30,36,44,45,46,39,33,41,48,42,35,28,20 ]
	
	var _generated_arr_pattern = [1,2,3,4] //default
	
	if _grid_sz = 3 {
		_generated_arr_pattern = choose(_generated_arr_pattern_3_1,_generated_arr_pattern_3_2,_generated_arr_pattern_3_3)
	} else if _grid_sz = 4 {
		_generated_arr_pattern = choose(_generated_arr_pattern_4_1,_generated_arr_pattern_4_2,_generated_arr_pattern_4_3)
	} else if _grid_sz = 5 {
		_generated_arr_pattern = choose(_generated_arr_pattern_5_1,_generated_arr_pattern_5_2,_generated_arr_pattern_5_3)
	} else if _grid_sz = 6 {
		_generated_arr_pattern = choose(_generated_arr_pattern_6_1,_generated_arr_pattern_6_2,_generated_arr_pattern_6_3,_generated_arr_pattern_6_4)
	} else if _grid_sz = 7 {
		_generated_arr_pattern = choose(_generated_arr_pattern_7_1,_generated_arr_pattern_7_2,_generated_arr_pattern_7_3)
	} else if _grid_sz = 8 {
		//_generated_arr_pattern = choose(_generated_arr_pattern_5_1,_generated_arr_pattern_5_2)
	}
	
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
		
		spawn_slam = 2+(-0.5*tile_col*(1/global.game_grid_size))+(-0.5*tile_row*(1/global.game_grid_size))	
		image_angle = (-120+random(240))
		
		
		
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