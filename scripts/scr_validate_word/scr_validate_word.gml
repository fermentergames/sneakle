///
function scr_validate_word() {
	if (live_call()) return live_result;
	
	var _valid_guess = 1
	var _already_guessed = 0
	selected_word_not_in_dictionary = 0 //reset
	selected_word_already_guessed = 0 //reset
	selected_word_is_valid = 1 //reset
	selected_word_base_points = 0 //reset
	
	if selected_word_length <= 3 {
		_valid_guess = 0
		selected_word_is_valid = 0
	}
	
	
	
	
	//show_debug_message(selected_word_array)
	
	
	if _valid_guess = 1 {
		
		
		

		
		var _letters_str = ""
		for (var l = 0; l < selected_word_length; ++l) {
			_letters_str += global.letters_grid[selected_word_array[l]]
			selected_word_base_points += global.letter_data[selected_word_array_id[l].my_letter_num,LETTER_POINTS]
		}
		selected_word_str = _letters_str
		
		
		//show_debug_message("guesses_list: "+string(guesses_list))
		
		for (var g = 1; g < array_length(guesses_list); ++g) {
			
			//show_debug_message("guess #: "+string(g))
			if guesses_list[g] = string(selected_word_str) {
				_already_guessed = 1
				_valid_guess = 0
				//show_debug_message("selected word already guessed: "+string(selected_word_str))
				selected_word_already_guessed = 1
				selected_word_is_valid = 0
			}
		}
				
		//show_debug_message("selected word is: "+string(selected_word_str))
		//show_debug_message("length: "+string(selected_word_length))
		//show_debug_message("points: "+string(selected_word_base_points)+" x "+string(selected_word_length)+" = "+string(selected_word_base_points*selected_word_length))	

		//show_debug_message(global.dictionary)
		
		if _already_guessed = 0 {
				
			var word = string_lower(selected_word_str)
			if (global.dictionary.check(word)) {
				//show_debug_message("\"" + word + "\" is a valid English word.");
				if global.am_creating >= 1 {
					if (global.dictionary_simple.check(word)) {
						selected_word_is_valid = 2 //extra valid if checked with simple dictionary
					}
				}
				
			} else {
				//show_debug_message("\"" + word + "\" is not a valid English word.");
				_valid_guess = 0
				selected_word_not_in_dictionary = 1
				selected_word_is_valid = 0
				selected_word_base_points = 0
			}
		
		}
				
	}
	
	nonstandard_used = 0 //reset
	
	if _valid_guess = 0 {
		if nonstandard_allowed = 1 {
			if selected_word_length >= 2 {
				_valid_guess = 1
				nonstandard_used = 1
				selected_word_is_valid = 3 //
			}
		}
	}
	
	if _valid_guess = 0 {
		if selected_word_length >= 2 {
			if real(obj_ctrlp.postData_nonStandard) >= 1 {
				_valid_guess = 1
				selected_word_is_valid = 3
			}
		}
	}
	
	//make sure nonstandard_used tag gets added even if allowed is off
	if nonstandard_used <= 0 {
		
		if selected_word_is_valid = 1 { //only 1 not in simple dict
			nonstandard_used = 1
		}
		if selected_word_length <= 4 { //needs to be >= 5
			nonstandard_used = 1
		}
		//if string_ends_with(string(selected_word_str),"S") {
		//	nonstandard_used = 1
		//}
	}

	
	return _valid_guess;
}