///
if (live_call()) return live_result;


draw_set_alpha(1)
draw_set_color(c_black)
//gpu_set_blendmode(bm_add)


if selected_word_length >= 0 && (selecting = 1 || global.game_phase = 2 || global.game_phase = 4) && is_array(selected_word_array_id) {


	var _line_base_sat = 255
	var _line_darken = 0
	if global.game_phase = 4 {
		_line_base_sat = 50
		_line_darken = -0.45+selected_word_array_id[0].am_selected_fd*-0.9
	}

	var _swa0_col = selected_word_array_id[0].image_blend

	var _line_hue = color_get_hue(_swa0_col)
	var _line_sat = color_get_saturation(_swa0_col)
	var _line_col = merge_color(_swa0_col,make_color_hsv(_line_hue,lerp(_line_sat,255,0.5),255*(selected_word_array_id[0].am_selected_fd)),0.0+(selected_word_array_id[0].am_selected_fd*0.6)+(selected_word_array_id[0].am_selected_flash2*0.3)+_line_darken)

	draw_set_color(_line_col)

	var _lx1 = selected_word_array_id[0].x
	var _ly1 = selected_word_array_id[0].y
	//draw_circle(_lx1,_ly1,24,0)

	//selected starting letter highlight
	draw_sprite_ext(spr_circ512,0,_lx1,_ly1,(48/512),(48/512),0,_line_col,1)

	if selected_word_length >= 2 {
	for (var l = 1; l < selected_word_length; ++l) {
		//
	
		//var _line_hue = color_get_hue(selected_word_array_id[l-1].image_blend)
		//var _line_sat = color_get_saturation(selected_word_array_id[l-1].image_blend)
				_line_col = merge_color(selected_word_array_id[l-1].image_blend,	make_color_hsv(_line_hue,lerp(_line_sat,255,0.5),255*(selected_word_array_id[l].am_selected_fd)),0.0+(selected_word_array_id[l].am_selected_fd*0.6)+(selected_word_array_id[l].am_selected_flash2*0.3)+_line_darken)
		var	_line_hue = color_get_hue(selected_word_array_id[l].image_blend)
		var	_line_sat = color_get_saturation(selected_word_array_id[l].image_blend)
		var	_line_col2 = merge_color(selected_word_array_id[l].image_blend,	make_color_hsv(_line_hue,lerp(_line_sat,255,0.5),255*(selected_word_array_id[l].am_selected_fd)),0.0+(selected_word_array_id[l].am_selected_fd*0.6)+(selected_word_array_id[l].am_selected_flash2*0.3)+_line_darken)


		draw_set_color(_line_col)
	
		var _l_fd = clamp((selected_word_array_id[l].am_selected_fd*2)+selected_word_array_id[l].am_part_of_secret_word_fd,0,1)
	
	
		//show_debug_message("HEY"+string(l)+" "+string(_l_fd))
	
		var _lx1 = selected_word_array_id[l-1].x
		var _ly1 = selected_word_array_id[l-1].y
	
		var _lx2 = lerp(selected_word_array_id[l-1].x,selected_word_array_id[l].x,_l_fd)
		var _ly2 = lerp(selected_word_array_id[l-1].y,selected_word_array_id[l].y,_l_fd)
	
		//if global.game_phase = 2 && selecting = 0 {
		//	var _line_col3 = merge_color(selected_word_array_id[l].image_blend,c_white,0.15)

		//	draw_line_width_color(_lx1,_ly1,_lx2,_ly2,20,_line_col3,_line_col3)
		//}
	
		draw_line_width_color(_lx1,_ly1,_lx2,_ly2,16,_line_col,_line_col2)
		
		//draw_line_width_color(_lx1,_ly1,_lx2,_ly2,16,c_red,c_purple)
		
		//draw_circle(_lx2,_ly2,8,0)
		draw_sprite_ext(spr_circ512,0,_lx2,_ly2,(16/512),(16/512),0,_line_col2,1)
	}
	}

}




if secret_word_length >= 0 && (global.game_phase = 3) && is_array(secret_word_array_id) && global.game_hint_letter_used >= 1 && global.game_hints_used >= 1 {


	draw_set_alpha(0.4*(1+(0.4*(sin(obj_ctrl.timey*0.08)))))
	var _line_base_sat = 255
	var _line_darken = 0
	if global.game_phase = 4 {
		_line_base_sat = 50
		_line_darken = -0.45+secret_word_array_id[0].am_selected_fd*-0.9
	}

	var _swa0_col = secret_word_array_id[0].image_blend

	//var _line_hue = color_get_hue(_swa0_col)
	//var _line_sat = color_get_saturation(_swa0_col)
	var _line_col = make_color_hsv(36,150,250)//merge_color(_swa0_col,make_color_hsv(_line_hue,lerp(_line_sat,255,0.5),255*(1)),0.0+(1)+(secret_word_array_id[0].am_selected_flash2*0)+_line_darken)
	//merge_color(_swa0_col,c_white,0.2) //c_yellow //merge_color(_swa0_col,make_color_hsv(_line_hue,lerp(_line_sat,255,0.5),255*(secret_word_array_id[0].am_selected_fd)),0.0+(secret_word_array_id[0].am_selected_fd*0.6)+(secret_word_array_id[0].am_selected_flash2*0.3)+_line_darken)

	draw_set_color(_line_col)

	var _lx1 = secret_word_array_id[0].x
	var _ly1 = secret_word_array_id[0].y
	//draw_circle(_lx1,_ly1,24,0)

	//selected starting letter highlight
	draw_sprite_ext(spr_circ512,0,_lx1,_ly1,(32/512),(32/512),0,_line_col,draw_get_alpha())

	if secret_word_length >= 2 {
	for (var l = 1; l < global.game_hint_letter_used; ++l) {
		//
	
		//var _line_hue = color_get_hue(selected_word_array_id[l-1].image_blend)
		//var _line_sat = color_get_saturation(selected_word_array_id[l-1].image_blend)
				_line_col = _line_col//c_yellow//c_yellow,0.0+(secret_word_array_id[l].am_selected_fd*0.6)+(secret_word_array_id[l].am_selected_flash2*0.3)+_line_darken)
		//var	_line_hue = color_get_hue(secret_word_array_id[l].image_blend)
		//var	_line_sat = color_get_saturation(secret_word_array_id[l].image_blend)
		var	_line_col2 = _line_col//c_yellow//merge_color(secret_word_array_id[l].image_blend,	c_yellow,255*(secret_word_array_id[l].am_selected_fd)),0.0+(secret_word_array_id[l].am_selected_fd*0.6)+(secret_word_array_id[l].am_selected_flash2*0.3)+_line_darken)


		draw_set_color(_line_col)
		
	
		var _l_fd = 1//clamp((secret_word_array_id[l].am_selected_fd*2)+secret_word_array_id[l].am_part_of_secret_word_fd,0,1)
	
	
		//show_debug_message("HEY"+string(l)+" "+string(_l_fd))
	
		var _lx1 = lerp(secret_word_array_id[l-1].x,secret_word_array_id[l].x,0.35)
		var _ly1 = lerp(secret_word_array_id[l-1].y,secret_word_array_id[l].y,0.35)
	
		var _lx2 = lerp(secret_word_array_id[l-1].x,secret_word_array_id[l].x,0.65)
		var _ly2 = lerp(secret_word_array_id[l-1].y,secret_word_array_id[l].y,0.65)
	
		//if global.game_phase = 2 && selecting = 0 {
		//	var _line_col3 = merge_color(selected_word_array_id[l].image_blend,c_white,0.15)

		//	draw_line_width_color(_lx1,_ly1,_lx2,_ly2,20,_line_col3,_line_col3)
		//}
		
		//draw_set_alpha(0.4*(1+(0.4*(sin(((l)*-1)+(obj_ctrl.timey*0.08))))))
	
		draw_line_width_color(_lx1,_ly1,_lx2,_ly2,5,_line_col,_line_col2)
		
		//draw_line_width_color(_lx1,_ly1,_lx2,_ly2,16,c_red,c_purple)
		
		//draw_circle(_lx2,_ly2,8,0)
		//draw_sprite_ext(spr_circ512,0,secret_word_array_id[l].x,secret_word_array_id[l].y,(16/512),(16/512),0,_line_col2,draw_get_alpha())
	}
	}
	
	draw_set_alpha(1)

}




draw_set_alpha(1)
gpu_set_blendmode(bm_normal)


with (obj_tile_letter) {
	
	var _tile_ht = 5*sqr(1-am_selected_fd)*global.tile_raises
	var _spawn_slam = sqr(spawn_slam)*-1000
	
	if global.game_phase >= 2 {
	
	draw_set_alpha(lerp(0.6,1,clamp(am_selected_fd+am_clued_fd+am_part_of_secret_word_fd+(1*am_exed_fd),0,1)))
	draw_set_color(letter_col)//merge_color(letter_col,c_white,am_selected_fd))
	draw_set_color(merge_color(letter_col,c_white,am_selected_fd))

	var _text_offset_y = -0//20
	var _text_scl = my_text_scl*scl //20
	
	
	if global.game_mode = 2 && my_letter_num >= 1 {
	draw_set_color(merge_color(letter_col,c_yellow,clamp(am_selected_fd+am_part_of_secret_word_fd,0,1*obj_ctrl.selected_word_is_valid)))
	}

	draw_text_transformed(x+lengthdir_x(-_tile_ht+(_text_offset_y*scl),image_angle-90),y+lengthdir_y(-_tile_ht+(_text_offset_y*scl),image_angle-90)+_spawn_slam,string_upper(my_letter_str),_text_scl,_text_scl,image_angle)

	//draw_text_transformed(x+lengthdir_x(-_tile_ht+(_text_offset_y*scl),image_angle-90),y+lengthdir_y(-_tile_ht+(_text_offset_y*scl),image_angle-90)+_spawn_slam+24,tile_id,_text_scl*0.2,_text_scl*0.2,image_angle)

	if global.game_mode = 2 && my_letter_num >= 1 {
	draw_set_color(merge_color(letter_col,c_yellow,clamp(am_selected_fd+am_part_of_secret_word_fd,0,1*obj_ctrl.selected_word_is_valid)))
	draw_text_transformed(x+lengthdir_x(-_tile_ht+(_text_offset_y*scl),image_angle-90)+0,y+lengthdir_y(-_tile_ht+(_text_offset_y*scl),image_angle-90)+_spawn_slam+22,global.letter_data[my_letter_num,LETTER_POINTS],_text_scl*0.25,_text_scl*0.25,image_angle)
	}

	draw_set_color(c_white)	
	
	}
	
	if am_set_flash > 0 {
	//flash on set
	draw_sprite_ext(spr_sqr512,1,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*2*sqr(1-am_set_flash),image_yscale*2*sqr(1-am_set_flash),image_angle,c_white,image_alpha*2*am_set_flash)
	}
	
}

