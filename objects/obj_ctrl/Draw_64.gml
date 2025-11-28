if (live_call()) return live_result;

//global.pr = 3
var _pos_scl = global.pr //*(min(global.sw,720)/375)
var _scl = (global.sw/450)

if global.is_landscape = 1 {
	_scl = (global.sh/850)
}

//if keyboard_check(vk_shift) {
//	//_scl = 2
//}

//var _iscl = 1*(min(global.sw,min(640*_pos_scl,global.sh*1))/(375*_pos_scl))


//if global.is_landscape = 1 {
	//_iscl = lerp(1*(min(global.sw*1,min(720*_pos_scl,(global.sh*1)+(-200*_pos_scl)))/(375*_pos_scl)), 1*(min(global.sw,min(640*_pos_scl,global.sh*1))/(375*_pos_scl)), am_screenshotting_fd)
	
	//_iscl = 1*(min(global.sw,(global.sh*1)+(-200*_pos_scl))/(375*_pos_scl))	
	//_iscl = 1*(min(global.sw,min(640*_pos_scl,global.sh*1))/(375*_pos_scl))
	
//}

var _tscl = clamp(_scl*1,0.5*global.pr,2*global.pr)//0.5
//show_debug_message(_tscl)


var _highlight_blue = make_color_hsv(145,180,140)
var _overlay_blue = make_color_hsv(145,120,20)


gpu_set_tex_filter(true)
draw_set_font(fnt_main)

draw_set_alpha(1)
draw_set_color(c_white)

draw_set_halign(fa_center)
draw_set_valign(fa_middle)

//draw_set_color(make_color_hsv(160,150,150))
draw_set_color(c_white)
draw_set_alpha(0.3)
draw_text_transformed(global.sw/2,25*_pos_scl,"s n e a k l e",0.22*_tscl,0.22*_tscl,0)
//draw_text_transformed(global.sw/2,45*_pos_scl,_tscl,0.1*_tscl,0.1*_tscl,0)

//draw_set_color(c_white)
//draw_set_alpha(0.3)

//draw_set_halign(fa_left)
//draw_text_transformed(20,25,string(global.sw),0.2,0.2,0)
//draw_rectangle(0,0,global.sw*0.5,global.sh*0.5,1)
//draw_rectangle((global.sw/2)-((350*0.45)*global.cam_zoom),(global.sh/2)-((750*0.45)*global.cam_zoom),(global.sw/2)+((350*0.45)*global.cam_zoom),(global.sh/2)+((750*0.45)*global.cam_zoom),1)

draw_set_halign(fa_center)
draw_set_alpha(1)

draw_set_color(c_white)
draw_set_alpha(0.3)


if global.game_phase = 0 {
	
	draw_set_alpha(0.7)
	
	draw_sprite_ext(spr_sqr512,0,global.sw*0.2,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,_highlight_blue,1)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.8,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,c_white,0.02)
	
	draw_text_transformed(global.sw*0.2,global.sh*0.4,"DAILY",0.15*_tscl,0.15*_tscl,0)
	draw_text_transformed(global.sw*0.5,global.sh*0.4,"ARCHIVE",0.13*_tscl,0.13*_tscl,0)
	
	draw_set_alpha(0.1)
	
	draw_text_transformed(global.sw*0.8,global.sh*0.4,"HOW TO",0.13*_tscl,0.13*_tscl,0)
	
	draw_set_alpha(0.7)
	
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.2,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.35,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.65,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.8,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	
	draw_text_transformed(global.sw*0.2,global.sh*0.6,"CREATE\n3x3",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.35,global.sh*0.6,"CREATE\n4x4",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.5,global.sh*0.6,"CREATE\n5x5",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.65,global.sh*0.6,"CREATE\n6x6",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.8,global.sh*0.6,"CREATE\n7x7",0.1*_tscl,0.1*_tscl,0)
	
	
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.2,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.35,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.65,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.8,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,c_white,0.06)
	
	draw_text_transformed(global.sw*0.2,global.sh*0.7,"RANDOM\n3x3",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.35,global.sh*0.7,"RANDOM\n4x4",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.5,global.sh*0.7,"RANDOM\n5x5",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.65,global.sh*0.7,"RANDOM\n6x6",0.1*_tscl,0.1*_tscl,0)
	draw_text_transformed(global.sw*0.8,global.sh*0.7,"RANDOM\n7x7",0.1*_tscl,0.1*_tscl,0)
	
	
	draw_set_alpha(0.3)
	
} else if global.game_phase = 1 {
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,75*_pos_scl,"drag to rearrange the letters",0.15*_tscl,0.15*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)
	
	if global.game_mode = 1 {
	draw_sprite_ext(spr_sqr512,0,global.sw*0.3,global.sh-70*_pos_scl,0.3*_tscl,0.08*_tscl,0,c_white,0.06)
	draw_text_transformed(global.sw*0.3,global.sh-70*_pos_scl,"NEW LETTERS",0.12*_tscl,0.12*_tscl,0)
	
	draw_sprite_ext(spr_sqr512,0,global.sw*0.7,global.sh-70*_pos_scl,0.3*_tscl,0.08*_tscl,0,c_white,0.06)
	draw_text_transformed(global.sw*0.7,global.sh-70*_pos_scl,"TYPE LETTERS",0.12*_tscl,0.12*_tscl,0)
	}
	
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5,global.sh-10*_pos_scl,0.4*_tscl,0.08*_tscl,0,c_white,0.06)
	
	if global.game_mode = 1 {
		draw_text_transformed(global.sw*0.5,global.sh-10*_pos_scl,"activate points mode",0.12*_tscl,0.12*_tscl,0)
	} else {
		draw_text_transformed(global.sw*0.5,global.sh-10*_pos_scl,"exit points mode",0.12*_tscl,0.12*_tscl,0)
	}
	
	if ready_for_phase2 = 0 {
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-130*_pos_scl,0.3*_tscl,0.08*_tscl,0,c_white,0.06)
		draw_text_transformed(global.sw/2,global.sh-130*_pos_scl,"AUTOFILL",0.12*_tscl,0.12*_tscl,0)
	} else {
		
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-150*_pos_scl,0.65*_tscl,0.14*_tscl,0,c_white,0.06)
		

			draw_set_alpha(0.7+(-0.6*dragging_fd))
			draw_text_transformed(global.sw/2,global.sh-150*_pos_scl,"CONFIRM GRID",0.2*_tscl,0.2*_tscl,0)
		
		
		draw_set_alpha(0.7)
	}
	
	
	
} else if global.game_phase = 2 {
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,75*_pos_scl,"swipe to select your SECRET WORD",0.15*_tscl,0.15*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.18,global.sh-30*_pos_scl,0.25*_tscl,0.08*_tscl,0,c_white,0.06)
	draw_text_transformed(global.sw*0.18,global.sh-30*_pos_scl,"REARRANGE",0.12*_tscl,0.12*_tscl,0)
	
	
	
	draw_set_color(c_white)
	
	if ready_for_phase3 = 1 {
		draw_set_alpha(1)
		draw_sprite_ext(spr_sqr512,0,global.sw/2,(global.sh*1)+(-110*_pos_scl),0.65*_tscl,0.15*_tscl,0,c_white,0.06)
		
		var _confirm_word_str = "CONFIRM SECRET WORD?"
		if global.game_mode = 2 {
			_confirm_word_str = "SUBMIT"
		}
		
		draw_text_transformed(global.sw/2,(global.sh*1)+(-110*_pos_scl),_confirm_word_str,0.15*_tscl,0.15*_tscl,0)
		draw_set_alpha(0.3)
	}
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	//draw_text_transformed(global.sw/2,(global.sh*1)+(-240*_pos_scl),"your SECRET WORD is",0.12*_tscl,0.12*_tscl,0)
	draw_text_transformed(global.sw/2,(global.sh*0)+(500*_scl),"your SECRET WORD is",0.12*_tscl,0.12*_tscl,0)
	draw_set_font(fnt_main)

	
	var _letters_str = ""
	for (var l = 0; l < selected_word_length; ++l) {
		_letters_str += global.letters_grid[selected_word_array[l]]
	}
	
	draw_set_alpha(0.3)
	
	if selected_word_is_valid >= 1 {
		draw_set_alpha(0.7)
	}
	
	//draw_text_transformed(global.sw/2,(global.sh*1)+(-200*_pos_scl),string(_letters_str),0.3*_tscl,0.3*_tscl,0)
	draw_text_transformed(global.sw/2,(global.sh*0)+(540*_scl),string(_letters_str),0.3*_tscl,0.3*_tscl,0)
	
	draw_set_alpha(0.3)
	
	draw_set_font(fnt_main_r)
	
	if selected_word_length > 0 {
		if selected_word_length <= 3 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"too short",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_not_in_dictionary >= 1 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"not a valid word",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_already_guessed >= 1 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"already guessed",0.15*_tscl,0.15*_tscl,0)
		} else {
			//draw_text_transformed(global.sw/2,(global.sh*0.7)+(80*_pos_scl),selected_word_not_in_dictionary,0.15*_tscl,0.15*_tscl,0)
		}
	}

	draw_set_font(fnt_main)
	draw_set_alpha(1)
	
	//draw_text_transformed(global.sw/2,global.sh*0.7,"selected word is:\n"+string(_letters_str)+"\nlength:"+string(selected_word_length),0.12*_tscl,0.12*_tscl,0)
	//draw_text_transformed(global.sw/2,global.sh*0.8,"array:\n"+string(selected_word_array),0.12*_tscl,0.12*_tscl,0)
	
	
} else if global.game_phase = 3 {
	
	draw_set_alpha(0.3)
	
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,75*_pos_scl,"can you guess the SECRET WORD?",0.15*_tscl,0.15*_tscl,0)
	draw_set_font(fnt_main)
	
	
	
	//draw_text_transformed(global.sw*0.15,global.sh-30*_pos_scl,"BACK",0.12*_tscl,0.12*_tscl,0)
	
	if ready_for_phase3 = 1 {
	//draw_text_transformed(global.sw*0.7,global.sh-30,"CONFIRM SECRET WORD",0.12*_tscl,0.12*_tscl,0)
	}

	
	var _letters_str = ""
	for (var l = 0; l < selected_word_length; ++l) {
		_letters_str += global.letters_grid[selected_word_array[l]]
	}
	
	draw_set_alpha(0.3)
	
	if selected_word_length >= 4 {
		draw_set_alpha(0.7)
	}
	
	if _letters_str != "" {
		draw_text_transformed(global.sw/2,(global.sh*0)+(540*_scl),string(_letters_str)+"?",0.3*_tscl,0.3*_tscl,0)
	}
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	if selected_word_length > 0 {
		if selected_word_length <= 3 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"too short",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_not_in_dictionary >= 1 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"not a valid word",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_already_guessed >= 1 {
			draw_text_transformed(global.sw/2,(global.sh*0)+(590*_scl),"already guessed",0.15*_tscl,0.15*_tscl,0)
		}
	}
	//draw_text_transformed(global.sw/2,global.sh*0.8,"array:\n"+string(selected_word_array),0.12*_tscl,0.12*_tscl,0)
	
	draw_set_valign(fa_top)
	draw_set_font(fnt_main_r)
	var _guesses_str = " guesses"
	if guesses_count = 1 {_guesses_str = " guess"}
	draw_text_transformed(global.sw/2,(global.sh*0)+(620*_scl),string(guesses_count)+string(_guesses_str),0.12*_tscl,0.12*_tscl,0)
	
	var _guess_list_str = ""
	for (var i = 1; i < array_length(guesses_list); ++i) {
		_guess_list_str += guesses_list[i]
		if i < array_length(guesses_list)-1 {
			_guess_list_str += ", "
		}
	}
	
	draw_text_ext_transformed(global.sw/2,(global.sh*0)+(650*_scl),string(_guess_list_str),150,global.sw*0.45*10,0.1*_tscl,0.1*_tscl,0)
	
	
	draw_set_valign(fa_middle)
	draw_set_font(fnt_main)
	
} else if global.game_phase = 4 {
	
	draw_set_font(fnt_main_r)
	
	draw_sprite_ext(spr_checkmark,0,global.sw/2,(global.sh*0.1)+(30*_pos_scl),1*_tscl,1*_tscl,0,c_white,0.04)
	draw_text_transformed(global.sw/2,(global.sh*0.1)+(30*_pos_scl),"complete!",0.15*_tscl,0.15*_tscl,(0+(5*(sin(obj_ctrl.timey*0.06)))))
	draw_set_font(fnt_main)
	
	
	
	//draw_text_transformed(global.sw*0.15,global.sh-30,"BACK",0.12*_tscl,0.12*_tscl,0)
	
	if ready_for_phase3 = 1 {
	//draw_text_transformed(global.sw*0.7,global.sh-30,"CONFIRM SECRET WORD",0.12*_tscl,0.12*_tscl,0)
	}
	
	var _letters_str = ""
	//for (var l = 0; l < selected_word_length; ++l) {
	//	_letters_str += global.letters_grid[selected_word_array[l]]
	//}
	
	if 1=1 {//global.game_phase = 4 {
		_letters_str = secret_word_str	
	}
	
	draw_set_valign(fa_top)
	
	draw_set_font(fnt_main_r)
	
	if global.gave_up = 0 {
		draw_text_transformed(global.sw/2,global.sh*0.7,"SECRET WORD found!",0.2*_tscl,0.2*_tscl,0)
	} else {
		draw_text_transformed(global.sw/2,global.sh*0.7,"gave up... SECRET WORD was:",0.2*_tscl,0.2*_tscl,0)
	}
	//draw_text_transformed(global.sw/2,global.sh*0.8,"\n\n\n\n"+string(guesses_count)+" guesses",0.15*_tscl,0.15*_tscl,0)
	

	draw_set_font(fnt_main)
	draw_set_alpha(1)
	
	//draw_sprite_ext(spr_checkmark,0,global.sw/2,(global.sh*0.7)+(50*_pos_scl),1*_tscl,1*_tscl,0,c_white,0.06)
	
	draw_text_transformed(global.sw/2,(global.sh*0.7)+(35*_pos_scl),string(_letters_str),0.3*_tscl,0.3*_tscl,0)
	
	draw_set_font(fnt_main_r)
	
	draw_set_alpha(0.3)
	var _guesses_str = " guesses"
	if guesses_count = 1 {_guesses_str = " guess"}
	draw_text_transformed(global.sw/2,(global.sh*0.7)+(100*_pos_scl),string(guesses_count)+string(_guesses_str),0.12*_tscl,0.12*_tscl,0)
	
	var _guess_list_str = ""
	for (var i = 1; i < array_length(guesses_list); ++i) {
		_guess_list_str += guesses_list[i]
		if i < array_length(guesses_list)-1 {
			_guess_list_str += ", "
		}
	}
	
	draw_text_ext_transformed(global.sw/2,(global.sh*0.7)+(125*_pos_scl),string(_guess_list_str),150,global.sw*0.45*10,0.1*_tscl,0.1*_tscl,0)
	
	draw_set_valign(fa_middle)
	draw_set_alpha(1)
	//var _letters_str = ""
	//for (var l = 0; l < selected_word_length; ++l) {
	//	_letters_str += global.letters_grid[selected_word_array[l]]
	//}
	
	//draw_text_transformed(global.sw/2,global.sh*0.7,"selected word is:\n"+string(_letters_str)+"\nlength:"+string(selected_word_length),0.12*_tscl,0.12*_tscl,0)
	//draw_text_transformed(global.sw/2,global.sh*0.8,"array:\n"+string(selected_word_array),0.12*_tscl,0.12*_tscl,0)
	
	
}


if global.game_phase = 1 || global.game_phase = 2 {
	if global.game_mode = 2 {
		
		
		
		
		draw_set_alpha(0.3)
		draw_set_color(c_red)
		if obj_ctrl.selected_word_base_points > 0 {
			draw_set_alpha(0.7)
			draw_set_color(c_yellow)
		}
		draw_text_transformed(global.sw*0.82,global.sh-40*_pos_scl,string(obj_ctrl.selected_word_base_points)+"x"+string(obj_ctrl.selected_word_length)+"="+string(obj_ctrl.selected_word_base_points*obj_ctrl.selected_word_length),0.12*_tscl,0.12*_tscl,0)
		
		//global.points_total = 0
		//global.words_made = 0
		//global.rearranges_used = 0
		//global.discards_used = 0
		
		draw_set_alpha(0.7)
		draw_set_color(c_white)
		
		var _next_letters = ""
		for (var i = 0; i < 5; ++i) {
		   _next_letters += global.letters_bag[i]
		}
		
		draw_text_transformed(global.sw*0.82,global.sh-105*_pos_scl,"next letters: "+string(_next_letters),0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.82,global.sh-90*_pos_scl,"words_made: "+string(global.words_made),0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.82,global.sh-75*_pos_scl,"rearranges_used: "+string(global.rearranges_used),0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.82,global.sh-60*_pos_scl,"discards_used: "+string(global.discards_used),0.1*_tscl,0.1*_tscl,0)
		
		draw_set_color(c_yellow)
		draw_set_alpha(0.7)
		draw_text_transformed(global.sw*0.82,global.sh-20*_pos_scl,"TOTAL: "+string(global.points_total),0.12*_tscl,0.12*_tscl,0)
	
	
		draw_set_alpha(1)
		draw_set_color(c_white)
	}	
}


draw_set_alpha(1)
//draw_text_transformed(global.sw*0.1,25*_pos_scl,"phase "+string(global.game_phase),0.1*_tscl,0.1*_tscl,0)

//top menu
draw_set_font(fnt_main)
draw_set_alpha(0.6)

if global.game_phase >= 1 {
draw_text_transformed(global.sw*0.1,25*_pos_scl,"menu",0.12*_tscl,0.12*_tscl,0)
}

if global.game_phase >= 3 {
	
	draw_set_alpha(0.6)
	var _sscl = 0.12
	if global.game_phase >= 4 {
		draw_set_alpha(0.8*(0.8+(0.4*(sin(obj_ctrl.timey*0.08)))))
		_sscl = 0.12*(1+(0.1*(sin(obj_ctrl.timey*0.08))))
		
		draw_sprite_ext(spr_sqr512,0,global.sw*0.9,25*_pos_scl,1.2*_sscl*_tscl,0.6*_sscl*_tscl,0,make_color_hsv(100,255,210),draw_get_alpha()*1.2)
	}
	
	draw_text_transformed(global.sw*0.9,25*_pos_scl,"share",_sscl*_tscl,_sscl*_tscl,0)
	
	if global.game_phase < 4 {
		draw_text_transformed(global.sw*0.1,global.sh*1+(-25*_pos_scl),"give up",0.12*_tscl,0.12*_tscl,0)
	} else if global.game_phase = 4 {
		draw_text_transformed(global.sw*0.1,global.sh*1+(-35*_pos_scl),"play\nanother",0.12*_tscl,0.12*_tscl,0)
	}

}

draw_set_alpha(1)



//for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
//   //draw_text_transformed(global.tile_letter[i].x,global.tile_letter[i].y,i,0.2,0.2,0)
//}



if selected_word_length > 0 {
	for (var l = 0; l < selected_word_length; ++l) {
		//draw_line_width(selected_word_array[l]
	}	
}


if keyboard_check(vk_control) {
	draw_set_alpha(1)
	draw_set_color(c_aqua)
	draw_text_transformed(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,string(device_mouse_x_to_gui(0)*global.pr)+","+string(device_mouse_y_to_gui(0)*global.pr),0.1*_tscl,0.1*_tscl,0)
	
	
	draw_circle(0,0,50,1)
	draw_circle(global.sw,global.sh,50,1)
	
	
	
	draw_set_color(c_white)
}

//gpu_set_blendmode(bm_add)
//draw_set_alpha(0.05)
//draw_rectangle_color(0,global.sh*0.7,global.sw,global.sh,c_black,c_black,c_white,c_white,0)
//draw_set_alpha(1)
//gpu_set_blendmode(bm_normal)




if global.show_input_prompt = 1 {
	
	draw_set_alpha(0.7*global.show_any_menu_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	//Render a div with fancy css
	var form_container = html_div(undefined, "form-container","Forms","form-container");
	
	//close button
	var closebtn = html_form(form_container, "closebtn-form");
	html_submit(closebtn, "closebtn", "Back", !form_is_loading, form_is_loading ? "loading" : "");
	if html_element_interaction(closebtn)
	html_submit_closebtn()
	
	//Render a form
	var form = html_form(form_container, "load-code");
	html_h3(form, "header", "Load Code")
	html_field(form, "loadCode", "loadCode", "Enter Code Here", true, "", "");
	html_submit(form, "submit", "Load", !form_is_loading, form_is_loading ? "loading" : "");
	if html_element_interaction(form)
	html_submit_code(form)
	

}

if global.show_export_prompt = 1 {
	
	draw_set_alpha(0.7*global.show_any_menu_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	//Render a div with fancy css
	var form_container = html_div(undefined, "form-container","Forms","form-container");
	
	//close button
	var closebtn = html_form(form_container, "closebtn-form");
	html_submit(closebtn, "closebtn", "Back", !form_is_loading, form_is_loading ? "loading" : "");
	if html_element_interaction(closebtn)
	html_submit_closebtn()
	
	//Render a form
	//var form2 = html_form(form_container, "export-code");
	//html_h3(form2, "header", "Export Code")
	//html_field(form2, "exportCode", "exportCode", "", true, "", string(global.current_copy_code));
	//html_submit(form2, "copycode", "Copy", !form_is_loading, form_is_loading ? "loading" : "");
	//if html_element_interaction(form2)
	//html_submit_export(form2)
	
	//Render a form
	var form3 = html_form(form_container, "export-link");
	html_h3(form3, "header", "Export Link")
	html_field(form3, "exportLink", "exportLink", "", true, "", string(global.current_copy_url));
	html_submit(form3, "copylink", "Copy", !form_is_loading, form_is_loading ? "loading" : "");
	if html_element_interaction(form3)
	html_submit_export_link(form3)
	
}

if global.show_archives = 1 {
	
	draw_set_alpha(0.7*global.show_any_menu_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	
	//Render a div with fancy css
	var archives_container = html_div(undefined, "puzzleMenuWrapper","","archives-container");
	
	var puzzleMenuHeader = html_div(archives_container, "puzzleMenuHeader","Archives","puzzleMenuHeader");
	html_h2(puzzleMenuHeader, "puzzleMenuH2","Archives","puzzleMenuH2");

	//close button
	var closebtn = html_form(puzzleMenuHeader, "closebtn-form");
	html_submit(closebtn, "closebtn", "Close", !form_is_loading, form_is_loading ? "loading" : "");
	if html_element_interaction(closebtn)
	html_submit_closebtn()
	
	
	var puzzleMenu = html_div(archives_container, "puzzleMenu","i'm the ul","puzzleMenu");
	
}



if keyboard_check(vk_shift) {
draw_set_alpha(0.3)
draw_text_transformed(global.sw*0.5,(global.sh*1)-(40*_pos_scl),global.current_copy_code,0.07*_tscl,0.07*_tscl,0)
}

var _version_scl = 1
if global.game_phase <= 0 {
	_version_scl = 1.5
}

draw_set_font(fnt_main_r)
draw_set_alpha(0.2*_version_scl)
draw_text_transformed(global.sw*0.5,(global.sh*1)-(25*_version_scl*_pos_scl),"<3 @FermenterGames\n"+date_datetime_string(GM_build_date),0.07*_version_scl*_tscl,0.07*_version_scl*_tscl,0)
draw_set_font(fnt_main)

draw_set_alpha(1)


//with (obj_tile_letter) {
	
//	var _letter_hue = obj_ctrl.timey*0.2 mod 255
//	var _letter_hue = 140//obj_ctrl.timey*0.2 mod 255


//	if tile_id = 0 {
//		scl *= 4
//		image_xscale = scl
//		image_yscale = image_xscale	
//	}


//	image_alpha = 1
//	image_blend = make_color_hsv(lerp(_letter_hue,80,am_selected_fd),lerp(80,210,am_selected_fd),clamp(80+(80*am_set_flash2)+(180*am_selected_flash2)+(10*am_selected_fd),0,255))
//	border_col = merge_color(image_blend,c_white,0.3)
//	letter_col = c_white//merge_color(image_blend,c_white,0.7)
//	//letter_col = merge_color(letter_col,c_white,am_selected_fd)

//	var _exed_col = make_color_hsv(0,0,40)
//	//if am_samelettered = 1 {
//	//	_exed_col = make_color_hsv(40,120,80)
//	//}

//	if am_selected <= 0 {
//		image_blend = merge_color(image_blend,_exed_col,am_exed_fd*1)
//		letter_col = merge_color(letter_col,image_blend,am_exed_fd*0.8)
//		image_alpha = 1-(am_exed_fd*0.8)
//	}
	
//	image_blend = merge_color(image_blend,make_color_hsv(95,255,150),am_clued_fd*0.7)//*(1-am_selected_fd))
//	letter_col = merge_color(letter_col,make_color_hsv(70,0,255),am_clued_fd*0.9*(1-am_selected_fd))
//	//letter_col = merge_color(letter_col,c_black,am_selected_fd*1)
//	border_col = merge_color(border_col,make_color_hsv(70,255,255),am_clued_fd*0.7*(1-am_selected_fd))

	




//	//draw_self()

//	depth = -y

//	if am_dragging >= 1 {
//		depth = -y-2000
//	}




//	var shad_fd = clamp(am_dragging_fd+(1-born_fd),0,1)

//	var _spawn_slam = sqr(spawn_slam)*-1000
	
//	var _tile_ht = 5*sqr(1-am_selected_flash2)


//	var _tile_shape = 2
//	//shadow
//	draw_sprite_ext(spr_sqr512,_tile_shape,x+lengthdir_x(6*shad_fd,image_angle-90),y+lengthdir_y(6*shad_fd,image_angle-90),image_xscale*(1+(0.2*shad_fd)),image_yscale*(1+(0.2*shad_fd)),image_angle,c_black,0.3*shad_fd)


//	//bottom edge
//	draw_sprite_ext(spr_sqr512,_tile_shape,x,y+_spawn_slam,image_xscale,image_yscale,image_angle,border_col,image_alpha)

//	//flash on set
//	draw_sprite_ext(spr_sqr512,1,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*2*sqr(1-am_set_flash),image_yscale*2*sqr(1-am_set_flash),image_angle,make_color_hsv(38,0,255),image_alpha*2*am_set_flash)

//	//main tile
//	draw_sprite_ext(spr_sqr512,_tile_shape,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale,image_yscale,image_angle,image_blend,image_alpha)

//	gpu_set_blendmode(bm_add)
//	//selected glow
//	draw_sprite_ext(spr_sqr512_glow,0,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*(0.7+(0.3*am_selected_fd)),image_yscale*(0.7+(0.3*am_selected_fd)),image_angle,image_blend,image_alpha*(am_selected_fd+am_selected_flash2))
//	//clued glow
//	draw_sprite_ext(spr_sqr512_glow,1,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale,image_yscale,image_angle,image_blend,image_alpha*am_clued_fd*0.5)


//	gpu_set_blendmode(bm_normal)


//	//scribble(my_letter_str)
//	////.scale_to_box(-1, 650*_pos_scl, -1)
//	//.line_spacing("55%")
//	//.starting_format(font_get_name(draw_get_font()), letter_col)
//	//.blend(c_white, draw_get_alpha())
//	//.align(fa_center, fa_middle)
//	//.transform(2.5*scl,2.5*scl,image_angle)
//	//.draw(x+lengthdir_x(-4+(50*scl),image_angle-90),y+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)

//	draw_set_alpha(lerp(0.6,1,clamp(am_selected_fd+am_clued_fd,0,1)))
//	draw_set_color(letter_col)//merge_color(letter_col,c_white,am_selected_fd))
//	draw_set_color(merge_color(letter_col,c_white,am_selected_fd))

//	var _text_offset_y = -20//20
//	var _text_scl = my_text_scl*scl //20

//	draw_text_transformed(x+lengthdir_x(-_tile_ht+(_text_offset_y*scl),image_angle-90),y+lengthdir_y(-_tile_ht+(_text_offset_y*scl),image_angle-90)+_spawn_slam,string_lower(my_letter_str),_text_scl,_text_scl,image_angle)

//	draw_set_color(c_white)

//	//if global.game_phase = 3 && 1=0 {
	
//	//	scribble(am_exed)
//	//	//.scale_to_box(-1, 650*_pos_scl, -1)
//	//	.line_spacing("55%")
//	//	.starting_format(font_get_name(draw_get_font()), letter_col)
//	//	.blend(c_white, draw_get_alpha()*0.7)
//	//	.align(fa_center, fa_middle)
//	//	.transform(1*scl,1*scl,image_angle)
//	//	.draw(x+22+lengthdir_x(-4+(50*scl),image_angle-90),y+15+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)


//	//	scribble(am_clued)
//	//	//.scale_to_box(-1, 650*_pos_scl, -1)
//	//	.line_spacing("55%")
//	//	.starting_format(font_get_name(draw_get_font()), letter_col)
//	//	.blend(c_white, draw_get_alpha()*0.7)
//	//	.align(fa_center, fa_middle)
//	//	.transform(1*scl,1*scl,image_angle)
//	//	.draw(x-22+lengthdir_x(-4+(50*scl),image_angle-90),y+15+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)

//	//}

//	if am_exed = 1 && am_selected <= 0 {
//	//exed
//	draw_sprite_ext(spr_sqr512,4,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*0.8,image_yscale*0.8,image_angle+45,letter_col,image_alpha*1)

//	}
	
//}

