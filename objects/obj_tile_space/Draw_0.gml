if (live_call()) return live_result;




if global.game_phase = 1 && global.game_phase = 2 {
	
	image_alpha = 0.02
	
	if mouse_check_button(mb_left) {
		if point_distance(mouse_x,mouse_y,x,y)	< 30 {
			image_alpha = 0.1
		}
	}

	draw_sprite_ext(spr_sqr512,2,x,y+0,image_xscale*0.9,image_yscale*0.9,image_angle,c_white,image_alpha)

}

//draw_self()



//if 1=0 {

//var _str = tile_id

//scribble(_str)
////.scale_to_box(-1, 650*_scl, -1)
//.line_spacing("55%")
//.starting_format(font_get_name(draw_get_font()), draw_get_color())
//.blend(c_white, draw_get_alpha()*0.2)
//.align(fa_center, fa_middle)
//.transform(0.25,0.25,0)
//.draw(x,y-5)

//var _str = tile_filled//string(tile_row)+","+string(tile_col)

//scribble(_str)
////.scale_to_box(-1, 650*_scl, -1)
//.line_spacing("55%")
//.starting_format(font_get_name(draw_get_font()), draw_get_color())
//.blend(c_white, draw_get_alpha()*0.2)
//.align(fa_center, fa_middle)
//.transform(0.1,0.1,0)
//.draw(x,y+15)

//}
