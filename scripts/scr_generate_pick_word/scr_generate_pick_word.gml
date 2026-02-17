///
function scr_generate_pick_word(){
if (live_call()) return live_result;

	//generate a random word, picking from a chosen length-based dictionary
	var _generated_word_length = choose(5,6,6,6,7,7,7,8,8,9,9,10,11,12)
	
	if global.game_grid_size = 3 {
		//_generated_word_length = clamp(_generated_word_length,5,9)	
		_generated_word_length = choose(5,6,6,7,7,8,8,9)
	}
	
	
	show_debug_message("_generated_word_length = "+string(_generated_word_length))
	
	global.dictionary_generate = new PickWordDictionary(working_directory + "dictionaries/simpler_MIT_by_length/"+string(_generated_word_length)+".txt");
	
	//print entire dictionary
	//show_debug_message(global.dictionary_generate)

	var _generated_word_is_valid = 0
	
	do {
	   var _generated_word = global.dictionary_generate.pick()
		
		//_generated_word = "chevrolet"
		show_debug_message("_generated_word = "+string(_generated_word))
	
		if 1=0 {//string_ends_with(_generated_word,"s") {
			show_debug_message("string_ends_with 'S'!!! TRY AGAIN (same length)")
		} else {
			if !(global.dictionary_simple.check(_generated_word)) {
				show_debug_message("\"" + _generated_word + "\" is not a valid English word.");
			} else {
				show_debug_message("\"" + _generated_word + "\" is a valid English word.");
				_generated_word_is_valid = 1
			}
		}
	} until (_generated_word_is_valid = 1);
	
	show_debug_message("_generated_word_is_valid!")
	
	
	
	//_generated_word = "HARMONY" //debug
	
	_generated_word = string_upper(_generated_word)
	show_debug_message(_generated_word)
	
	
	global.generated_word = _generated_word

}