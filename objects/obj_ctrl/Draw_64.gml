if (live_call()) return live_result;

gpu_set_tex_filter(true)

var _pos_scl = gui_pos_scl
var _scl = gui_sz_scl
var _tscl = gui_txt_scl *ctrl_fd

var _panel_bottom_y = gui_panel_bottom_y
var _panel_top_y = gui_panel_top_y
var _panel_mid_y = gui_panel_mid_y
var _nav_mid_y = gui_nav_mid_y


var _highlight_blue = make_color_hsv(145,180,140)
var _overlay_blue = make_color_hsv(145,120,20)
var _overlay_blue_dk = _overlay_blue
var _green_check_col = make_color_hsv(100,255,210)
var _green_check_txt = make_color_hsv(100,215,250)

var _c_gray = c_gray
var _c_white = c_white

if global.light_mode = 1 {
	_c_white = make_color_hsv(25,240,30)
	_overlay_blue = make_color_hsv(30,20,220)
	_green_check_txt = make_color_hsv(100,215,150)
}



draw_set_font(fnt_main)

draw_set_alpha(1)
draw_set_color(_c_white)


draw_set_halign(fa_center)
draw_set_valign(fa_middle)

	
if global.game_phase > 0 && 1=0 {
	//nav menu top
	draw_set_alpha(0.3)
	draw_set_color(_overlay_blue)
	draw_rectangle(0,0,global.sw,_panel_top_y,0)

	//scoring panel
	draw_set_alpha(0.15)
	draw_set_color(_overlay_blue)
	draw_rectangle(0,_panel_top_y,global.sw,_panel_bottom_y,0)

}
//




//draw_set_color(make_color_hsv(160,150,150))
draw_set_color(_c_white)
draw_set_alpha(0.3)
//draw_text_transformed(global.sw/2,_nav_mid_y,"s n e a k l e",0.22*_tscl,0.22*_tscl,0)

//draw_text_transformed(global.sw/2,_nav_mid_y,"s n e a k l e",0.22*_tscl,0.22*_tscl,0)

if global.game_phase != 0 {
	
	var _nav_logo_col = _c_white
	var _nav_logo_alp = 0.7
	if global.light_mode = 1 {
		_nav_logo_col = _highlight_blue
		_nav_logo_alp = 0.9
	}
	draw_sprite_ext(spr_sneakle_logo,0,(global.sw*0.0)+(20*_scl),_nav_mid_y,0.08*_tscl,0.08*_tscl,0,_nav_logo_col,_nav_logo_alp) 

}

//draw_text_transformed(global.sw/2,45*_pos_scl,_tscl,0.1*_tscl,0.1*_tscl,0)

//draw_set_color(_c_white)
//draw_set_alpha(0.3)

//draw_set_halign(fa_left)
//draw_text_transformed(20,25,string(global.sw),0.2,0.2,0)
//draw_rectangle(0,0,global.sw*0.5,global.sh*0.5,1)
//draw_rectangle((global.sw/2)-((350*0.45)*global.cam_zoom),(global.sh/2)-((750*0.45)*global.cam_zoom),(global.sw/2)+((350*0.45)*global.cam_zoom),(global.sh/2)+((750*0.45)*global.cam_zoom),1)

draw_set_halign(fa_center)
draw_set_alpha(1)

draw_set_color(_c_white)
draw_set_alpha(0.3)


//scr_mouse_over_button(global.sw*0.1,_nav_mid_y,0.1*_tscl,0.04*_tscl) { //if device_mouse_y_to_gui(0)*global.pr < 50*global.pr && device_mouse_x_to_gui(0)*global.pr < display_get_gui_width()*0.3 {
//draw_sprite_ext(spr_sqr512,0,global.sw*0.1,(global.sh+(-30*_pos_scl)),0.18*_tscl,0.12*_tscl,0,_c_white,0.2) 


if global.game_phase = 0 {
	
	//global.game_loading = 0
	
	if global.game_loading = 0 {
		
		
		obj_ctrlp.postData_dailyID = -1
		
		var _daily_id = string(obj_ctrlp.postData_dailyID)
		var _daily_btn_si = 4
		if _daily_id = "-1" {
			_daily_id = "-"
			_daily_btn_si = 3
		}
		
		draw_set_alpha(0.9*ctrl_fd)
		
		
		//gpu_set_blendmode(bm_add)
		
		if global.light_mode = 0 {
			draw_sprite_ext(spr_sneakle_logo_2,0,(global.sw*0.5)+(-6*_scl),0+(100*_scl)+(0*pulse_4*_scl)+(4*_scl),0.2*_scl*(1+(-0.02*pulse_1)),0.2*_scl*(1+(0.02*pulse_1)),0,c_black,0.2*ctrl_fd) 
			draw_sprite_ext(spr_sneakle_logo_2,0,(global.sw*0.5),0+(100*_scl)+(0*pulse_4*_scl),0.2*_scl*(1+(-0.02*pulse_1)),0.2*_scl*(1+(0.02*pulse_1)),0,_c_white,0.9*ctrl_fd) 
		} else {
			//draw_sprite_ext(spr_sneakle_logo_2,0,(global.sw*0.5)+(-6*_scl),0+(100*_scl)+(0*pulse_4*_scl)+(4*_scl),0.2*_scl*(1+(-0.02*pulse_1)),0.2*_scl*(1+(0.02*pulse_1)),0,c_white,0.6*ctrl_fd) 
			draw_sprite_ext(spr_sneakle_logo_2,0,(global.sw*0.5),0+(100*_scl)+(0*pulse_4*_scl),0.2*_scl*(1+(-0.02*pulse_1)),0.2*_scl*(1+(0.02*pulse_1)),0,_highlight_blue,1*ctrl_fd) 
		}

		//gpu_set_blendmode(bm_normal)
		
		draw_sprite_ext(spr_btn_6,_daily_btn_si,(global.sw*0.5),0+(220*_scl)+(110*_scl*0)+(6*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_6,_daily_btn_si,(global.sw*0.5),0+(220*_scl)+(110*_scl*0),0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
		draw_set_font(fnt_main)
		if _daily_id != "-" {
			draw_set_color(c_white)
			draw_text_transformed(global.sw/2,0+(220*_scl)+(110*_scl*0)+(15*_scl),_daily_id,0.17*_scl,0.17*_scl,0)
		}
		
		draw_set_color(c_white)
		
		
		draw_sprite_ext(spr_btn_6,5,(global.sw*0.5),0+(220*_scl)+(110*_scl*1)+(6*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_6,5,(global.sw*0.5),0+(220*_scl)+(110*_scl*1),0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
		
		//sep line
		draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(220*_scl)+(110*_scl*1)+(80*_scl),0.65*_scl,0.004*_scl,0,_c_white,0.2*ctrl_fd) 
	
	
		draw_set_alpha(0.6*ctrl_fd)
		draw_set_font(fnt_main)
		draw_set_color(_c_white)
		draw_text_transformed(global.sw/2,(220*_scl)+(110*_scl*1)+(130*_scl),"U N L I M I T E D",0.14*_tscl,0.14*_tscl,0)

		draw_set_alpha(0.9*ctrl_fd)
		draw_set_color(c_white)
		
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl)+(6*_scl)	,	0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl)+(6*_scl)	,		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-0*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl)+(6*_scl),		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl)+(6*_scl),		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl)+(6*_scl)	,		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),	0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-0*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
	
		draw_text_transformed((global.sw*0.5)+(-160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),"3x3",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(-80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),	"4x4",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(-0*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),	"5x5",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(80*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),	"6x6",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(160*_scl),0+(220*_scl)+(130*_scl*1)+(180*_scl),	"7x7",0.14*_tscl,0.14*_tscl,0)

		
		/*
	
		draw_set_alpha(0.7*ctrl_fd)
	
		draw_sprite_ext(spr_sqr512,0,global.sw*0.2,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,_highlight_blue,1*ctrl_fd)
		draw_sprite_ext(spr_sqr512,0,global.sw*0.5,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512,0,global.sw*0.8,global.sh*0.4,0.18*_tscl,0.18*_tscl,0,_c_white,0.02*ctrl_fd)
	
		draw_text_transformed(global.sw*0.2,global.sh*0.4,"DAILY",0.15*_tscl,0.15*_tscl,0)
		draw_text_transformed(global.sw*0.5,global.sh*0.4,"ARCHIVE",0.13*_tscl,0.13*_tscl,0)
	
		draw_set_alpha(0.1*ctrl_fd)
	
		draw_text_transformed(global.sw*0.8,global.sh*0.4,"HOW TO",0.13*_tscl,0.13*_tscl,0)
	
		draw_set_alpha(0.7*ctrl_fd)
	
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.2,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.35,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.65,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.8,global.sh*0.6,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
	
		draw_text_transformed(global.sw*0.2,global.sh*0.6,"CREATE\n3x3",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.35,global.sh*0.6,"CREATE\n4x4",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.5,global.sh*0.6,"CREATE\n5x5",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.65,global.sh*0.6,"CREATE\n6x6",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.8,global.sh*0.6,"CREATE\n7x7",0.1*_tscl,0.1*_tscl,0)
	
	
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.2,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.35,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.65,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.8,global.sh*0.7,0.12*_tscl,0.12*_tscl,0,_c_white,0.06*ctrl_fd)
	
		draw_text_transformed(global.sw*0.2,global.sh*0.7,"RANDOM\n3x3",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.35,global.sh*0.7,"RANDOM\n4x4",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.5,global.sh*0.7,"RANDOM\n5x5",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.65,global.sh*0.7,"RANDOM\n6x6",0.1*_tscl,0.1*_tscl,0)
		draw_text_transformed(global.sw*0.8,global.sh*0.7,"RANDOM\n7x7",0.1*_tscl,0.1*_tscl,0)
	
	
		draw_set_alpha(0.3*ctrl_fd)
		
		*/
	
	} 
	
} else if global.game_phase = 1 {
	
	draw_set_color(_c_white)
	
	draw_set_alpha(0.4)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,70*_scl,"drag to rearrange the letters",0.18*_tscl,0.18*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)
	
	if global.game_mode = 1 {
		
		var _btn_alps = 1+(dragging_fd*-0.6)
		var _btn_cols = merge_colour(global.background_col,_c_white,0.1+(global.light_mode*0.1))
		
		draw_set_color(_c_white)
		
		if dragging > 0 {
			_btn_cols = merge_colour(global.background_col,c_dkgray,0.4)
			draw_set_color(c_gray)
		}
		
		draw_set_alpha(0.7*_btn_alps)
		
		
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-182*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-182*_scl),global.sh-(160*_scl),"3x3",0.12*_tscl,0.12*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-91*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-91*_scl),global.sh-(160*_scl),"4x4",0.12*_tscl,0.12*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-0*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-0*_scl),global.sh-(160*_scl),"5x5",0.12*_tscl,0.12*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(91*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(91*_scl),global.sh-(160*_scl),"6x6",0.12*_tscl,0.12*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(182*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(182*_scl),global.sh-(160*_scl),"7x7",0.12*_tscl,0.12*_tscl,0)
	
	
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				
				var _which_sz_clicked = -1
				
				if				scr_mouse_over_button((global.sw*0.5)+(-182*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl) {
					show_debug_message("3 CLICKED")
					_which_sz_clicked = 3
				} else if	scr_mouse_over_button((global.sw*0.5)+(-91*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl) {
					show_debug_message("4 CLICKED")
					_which_sz_clicked = 4
				} else if	scr_mouse_over_button((global.sw*0.5)+(-0*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl) {
					show_debug_message("5 CLICKED")
					_which_sz_clicked = 5
				} else if	scr_mouse_over_button((global.sw*0.5)+(91*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl) {
					show_debug_message("6 CLICKED")
					_which_sz_clicked = 6
				} else if	scr_mouse_over_button((global.sw*0.5)+(182*_scl),global.sh-(160*_scl),0.12*_tscl,0.12*_tscl) {
					show_debug_message("7 CLICKED")
					_which_sz_clicked = 7
				}
				
				
				if _which_sz_clicked != -1 {
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
					//reset board first
					
					with (obj_tile_letter) {
						instance_destroy()
					}
					with (obj_tile_space) {
						instance_destroy()
					}

					global.am_creating = 1
				
					global.loadSecret = ""
					global.loadBoard = ""
					global.current_copy_code = ""
					global.current_copy_link = ""
					scr_update_copy_code()
					
					
					//now setup new board with new sz
					
					
					global.game_grid_size = _which_sz_clicked
					global.game_grid_size_sqr = sqr(global.game_grid_size)
					global.am_creating = 1
					var _event_struct = { //
					   screen_name: "Create"+string(global.game_grid_size),
					};
					GoogHit("screen_view",_event_struct)
					scr_board_init()	
					
					//with (obj_tile_letter) {
					//	//instance_destroy()
					//	image_angle = 0
					//	born_fd = 1
					//	spawn_slam = 0
					//	am_set = 1
					//	am_set_fd = 1
					//	am_set_flash = 0
					//	x = x_targ
					//	y = y_targ
					//}
				}
				
			}
		}
	
	
		
	
		
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-148*_scl),global.sh-(240*_scl),0.25*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-148*_scl),global.sh-(240*_scl),"RANDOM\nLETTERS",0.12*_tscl,0.12*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(0*_scl),global.sh-(240*_scl),0.25*_tscl,0.12*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(0*_scl),global.sh-(240*_scl),"TYPE\nLETTERS",0.12*_tscl,0.12*_tscl,0)
	
		
		var _swap_alp = 0.1+dragging_fd
		var _swap_col = c_gray
		draw_set_color(_btn_cols)
		
		draw_set_alpha(0.7)
		
		if dragging > 0 {
			_swap_col = c_yellow
			draw_set_color(_c_white)
			draw_set_alpha(0.9+(0.2*obj_ctrl.pulse_2))
			_swap_alp = 0.1+(0.8*dragging_fd)+(0.2*obj_ctrl.pulse_2)
		}
		
		
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(148*_scl),global.sh-(240*_scl),0.25*_tscl*(1+(0.05*-obj_ctrl.pulse_2*dragging_fd)),0.12*_tscl*(1+(0.05*obj_ctrl.pulse_2*dragging_fd)),0,_swap_col,_swap_alp*0.5)
		
		draw_sprite_ext(spr_sqr512_tile_dotted,0,(global.sw*0.5)+(148*_scl),global.sh-(240*_scl),0.24*_tscl*(1+(0.05*-obj_ctrl.pulse_2*dragging_fd)),0.115*_tscl*(1+(0.05*obj_ctrl.pulse_2*dragging_fd)),0,_swap_col,-0.05+_swap_alp)
		
		draw_text_transformed((global.sw*0.5)+(148*_scl),global.sh-(240*_scl),"HOVER HERE\nTO CHANGE\nA LETTER",(0.09+(-0.02*dragging_fd))*_tscl,0.09*_tscl,0)
	
		draw_set_alpha(0+(0.8*dragging_fd))
		draw_text_transformed((global.sw*0.5)+(148*_scl),global.sh-(240*_scl),"-1                +1",0.15*_tscl*(1+(0.05*-obj_ctrl.pulse_2*dragging_fd)),0.15*_tscl,0)
	
	
		draw_set_color(_c_white)
		draw_set_alpha(0.7)
		
		
		if mouse_check_button(mb_left) && global.show_any_modal <= 0 {
			
			obj_ctrl.hovered_over_changer_timey += 1
			
			var _timey_mod = 30
			_timey_mod = floor(lerp(_timey_mod,5,(obj_ctrl.hovered_over_changer/14)))
			
			if dragging >= 1 && dragging_fd >= 0.5 && (obj_ctrl.hovered_over_changer_timey mod _timey_mod = 0) {
				if	scr_mouse_over_button((global.sw*0.5)+(148*_scl),global.sh-(240*_scl),0.25*_tscl,0.12*_tscl) {
					show_debug_message("X HELD")
					show_debug_message(_timey_mod)
					show_debug_message(obj_ctrl.hovered_over_changer)
					
					with (obj_tile_letter) {
						if am_dragging >= 1 && am_dragging_fd > 0.9 {
							
							obj_ctrl.hovered_over_changer += 1
							obj_ctrl.hovered_over_changer = clamp(obj_ctrl.hovered_over_changer,0,14)
							obj_ctrl.hovered_over_changer_timey = 1
							
							if (device_mouse_x_to_gui(0)*global.pr) <= ((global.sw*0.5)+(148*obj_ctrl.gui_sz_scl)) {
								show_debug_message("-1")
								if my_letter_num > 1 {
									my_letter_num -= 1	
								} else {
									my_letter_num = 26
								}
								

								
								audio_play_sound(snd_mm_click_003,0,0,0.1,0,2.2+(-0.1*obj_ctrl.hovered_over_changer))
								
							} else {
								show_debug_message("+1")
								if my_letter_num < 26 {
									my_letter_num += 1	
								} else {
									my_letter_num = 1	
								}
								
								audio_play_sound(snd_mm_click_003,0,0,0.1,0,0.8+(0.1*obj_ctrl.hovered_over_changer))
							}
							my_letter_str = global.letter_data[my_letter_num,1]
						
						}
					
					}
					
				} else {
					obj_ctrl.hovered_over_changer_timey = 0
					obj_ctrl.hovered_over_changer = 0
				}
			}
		}
		
	
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if				scr_mouse_over_button((global.sw*0.5)+(-148*_scl),global.sh-(240*_scl),0.25*_tscl,0.12*_tscl) {
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					show_debug_message("A CLICKED")
					
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
					
				} else if	scr_mouse_over_button((global.sw*0.5)+(-0*_scl),global.sh-(240*_scl),0.25*_tscl,0.12*_tscl) {
					show_debug_message("B CLICKED")
					
					show_debug_message("TYPE LETTERS")
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))

					var _event_struct = { //
					   screen_name: "LoadFromCreate",
					};
					GoogHit("screen_view",_event_struct)
					
					if 1=0 { //html5
					
						global.show_input_prompt = 1
					
					} else {
					
						var _current_board = string_letters(global.current_copy_code)
						if _current_board = "" {
							_current_board = "ABCDEFGHI"	
						} else {
							if string_count("_",_current_board) > 0 {
								_current_board = string_copy(_current_board,0,string_length(_current_board)-1)
							}
						}
						
						create_typed_letters = ""
						async_msg_letters = get_string_async("Enter the letters you want to use.\n(Length needs to be a square number: 9 | 16 | 25 | 36 | 49)\n(Excess length with be rounded down to nearest square number.)", string(_current_board)); 
						//will set create_typed_letters in async dialog
						
					
					}
					
				}
			}
		}
	
	
	}
	
	//draw_sprite_ext(spr_sqr512,0,global.sw*0.5,global.sh-10*_scl,0.4*_tscl,0.08*_tscl,0,c_white,0.06)
	
	//if global.game_mode = 1 {
	//	draw_text_transformed(global.sw*0.5,global.sh-10*_pos_scl,"activate points mode",0.12*_tscl,0.12*_tscl,0)
	//} else {
	//	draw_text_transformed(global.sw*0.5,global.sh-10*_pos_scl,"exit points mode",0.12*_tscl,0.12*_tscl,0)
	//}
	
	if ready_for_phase2 = 0 {
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl,0,_highlight_blue,1)
		
		draw_text_transformed(global.sw/2,global.sh-(65*_scl),"AUTOFILL",0.2*_scl,0.2*_scl,0)

		
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if		scr_mouse_over_button(global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl) {
					show_debug_message("C CLICKED")
					
					if _empty_tile_count >= 0 { //there are some empty spaces
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
		
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
	
					}
					
				}
			}
		}
		
	} else {
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl,0,merge_colour(_highlight_blue,c_white,0.4),1)
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-(65*_scl),0.819*_scl,0.17*_scl,0,_highlight_blue,1)
		

		draw_set_alpha(0.7+(-0.6*dragging_fd))
		draw_text_transformed(global.sw/2,global.sh-(75*_scl),"CONFIRM GRID",0.2*_scl,0.2*_scl,0)
		draw_text_transformed(global.sw/2,global.sh-(50*_scl),"proceed to set secret",0.12*_scl,0.12*_scl,0)
		
		draw_set_alpha(0.7)
		
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if		scr_mouse_over_button(global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl) {
					show_debug_message("D CLICKED")
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
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
			}
		}
		
	}
	
	
	
} else if global.game_phase = 2 {
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,75*_scl,"swipe to select your SECRET WORD",0.15*_tscl,0.15*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5+(-106*_scl),global.sh-28*_scl,0.42*_tscl,0.08*_tscl,0,_c_white,0.06)
	draw_text_transformed(global.sw*0.5+(-106*_scl),global.sh-28*_scl,"<  BACK TO REARRANGE",0.12*_tscl,0.12*_tscl,0)
	
	
	if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
		if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			if		scr_mouse_over_button(global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl) {
				//go back
				show_debug_message("E CLICKED")
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				global.game_phase = 1
				selected_word_length = 0
				selected_word_str = ""	
				with (obj_tile_letter) {
					am_part_of_secret_word = 0	
				}
			}
		}
	}
	
	
	
	draw_set_color(_c_white)
	
	if 1=1 {//ready_for_phase3 = 1 {
		draw_set_alpha(0.1+ready_for_phase3)
		var _confirm_word_col = c_maroon
		draw_set_color(c_gray)
		
		if ready_for_phase3 >= 1 {
			draw_set_color(_c_white)
			_confirm_word_col = _highlight_blue
		}
		
		
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,(_panel_mid_y)+(102*_scl),0.65*_tscl,0.13*_tscl,0,merge_colour(_confirm_word_col,c_white,0.4),draw_get_alpha())
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,(_panel_mid_y)+(102*_scl),0.641*_tscl,0.124*_tscl,0,_confirm_word_col,draw_get_alpha())
		
		var _confirm_word_str = "CONFIRM SECRET WORD?"
		if global.game_mode = 2 {
			_confirm_word_str = "SUBMIT"
		}
		
		
		
		draw_text_transformed(global.sw/2,(_panel_mid_y)+(102*_scl),_confirm_word_str,0.15*_tscl,0.15*_tscl,0)
		draw_set_alpha(0.3)
		
		
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if		scr_mouse_over_button(global.sw/2,(_panel_mid_y)+(102*_scl),0.65*_tscl,0.13*_tscl) {
					show_debug_message("F CLICKED")	
					if global.game_mode = 1 && selected_word_is_valid >= 1 {
						//proceed, lock in word
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
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
				
						global.show_submitting_post = 1
						
						create_title = ""
						if obj_ctrlp.username != "" {
							create_title = string(obj_ctrlp.username)
							create_title += "'s Custom Puzzle"
						} else {
							create_title = "Custom Puzzle"
						}
						
						async_msg_title = get_string_async("Enter a title for your puzzle and submit.\n(This will create a post as "+string(obj_ctrlp.username)+")", string(create_title)); 
						
						
						
						
				
						//global.game_phase = 3
						//just_phase_changed = 1
			
					}
				}
			}
		}
		
	}
	
	draw_set_color(_c_white)
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	//draw_text_transformed(global.sw/2,(global.sh*1)+(-240*_pos_scl),"your SECRET WORD is",0.12*_tscl,0.12*_tscl,0)
	draw_text_transformed(global.sw/2,(_panel_mid_y)+(-55*_scl),"your SECRET WORD is",0.12*_tscl,0.12*_tscl,0)
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
	draw_text_transformed(global.sw/2,(_panel_mid_y),string(_letters_str),0.4*_tscl,0.4*_tscl,0)
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	if selected_word_length > 0 {
		if selected_word_length <= 3 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(45*_scl),"too short",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_not_in_dictionary >= 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(45*_scl),"not a valid word",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_already_guessed >= 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(45*_scl),"already guessed",0.15*_tscl,0.15*_tscl,0)
		}
	}

	draw_set_font(fnt_main)
	draw_set_alpha(1)
	
	//draw_text_transformed(global.sw/2,global.sh*0.7,"selected word is:\n"+string(_letters_str)+"\nlength:"+string(selected_word_length),0.12*_tscl,0.12*_tscl,0)
	//draw_text_transformed(global.sw/2,global.sh*0.8,"array:\n"+string(selected_word_array),0.12*_tscl,0.12*_tscl,0)
	
	
}




//playing or victory
if global.game_phase = 3 || global.game_phase = 4 {
	
	
	draw_set_alpha(0.3)
	draw_set_color(_c_white)
	draw_set_font(fnt_main)
	
	var _panel_ht = abs(_panel_bottom_y-_panel_top_y)
	
	if global.game_phase != 4 {
		draw_set_font(fnt_main_r)
		draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.35),"can you guess the SECRET WORD?",0.15*_tscl,0.15*_tscl,0)
		draw_set_font(fnt_main)
	} else if global.game_phase = 4 {
		draw_set_font(fnt_main)
		draw_set_color(_c_white)
		draw_set_alpha((0.35+game_finished_flash2)*game_finished_fd2*2)
	
		if global.gave_up = 0 {
			draw_sprite_ext(spr_checkmark,0,global.sw/2+(0*_scl),(_panel_mid_y)+(_panel_ht*-0.39),(0.5+(0+(-0.02*(sin(obj_ctrl.timey*0.11)))))*(_tscl+(game_finished_flash2)),(0.5+(0+(0.02*(sin(obj_ctrl.timey*0.11)))))*(_tscl+(game_finished_flash2)),0,_green_check_col,(0.1+game_finished_flash2)*2*game_finished_fd2)
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.37),"w o r d   f o u n d !",0.13*(_tscl+(game_finished_flash2)),0.13*(_tscl+(game_finished_flash2)),(0+(3*(sin(obj_ctrl.timey*0.06)))))
		} else {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.37),"gave up :(",0.15*_tscl,0.15*_tscl,0) //(0+(3*(sin(obj_ctrl.timey*0.06)))))
		}
		
		if obj_ctrlp.already_finished >= 1 {
			draw_set_valign(fa_middle)
			draw_set_alpha(0.4)
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.44),"ALREADY PLAYED!",0.1*_tscl,0.1*_tscl,0)
		}
		
	}
	
	draw_set_alpha(1)
	draw_set_color(_c_white)
	

	var _letters_str = ""

	if global.game_phase = 4 {
		_letters_str = secret_word_str	
	} else {
		for (var l = 0; l < selected_word_length; ++l) {
			_letters_str += global.letters_grid[selected_word_array[l]]
		}
	}
	

	
	//if global.game_phase = 4 {
		
	//	draw_set_alpha(0.5)
	//	draw_set_font(fnt_main_r)
		
	//	if global.gave_up = 0 {
	//		draw_text_transformed(global.sw/2,(_panel_mid_y)+(-55*_scl),"SECRET WORD found!",0.2*_tscl,0.2*_tscl,0)
	//	} else {
	//		draw_text_transformed(global.sw/2,(_panel_mid_y)+(-55*_scl),"gave up... SECRET WORD was:",0.2*_tscl,0.2*_tscl,0)
	//	}
	//}

	
	draw_set_font(fnt_main)
	
	var _length_str = ""
	var _length_str_w = 0
	var _letters_str_w = 0
	var _letters_str_l = string_length(_letters_str)
	
	var _letters_scl = 0.45
	var _str_diff = 0
	
	
	
	if 1=1 {//_letters_str != "" {
		
		draw_set_alpha(0.3)
		if selected_word_length >= 4 {
			draw_set_alpha(0.7)
		}
			
		var _max_width = 350//290
		if global.game_phase = 3 && global.game_hint_length_used >= 1 {
			_max_width -= 30	
				
			_str_diff = string_length(secret_word_str) - _letters_str_l
			//if _str_diff >= 1 {
				//repeat (_str_diff) {
				//	_letters_str += "_"
				//}
			//}
		}
			
		
			
		draw_set_font(fnt_main)
		_letters_str_w = string_width(string(_letters_str)+"?")*_tscl
			  
		_letters_scl = min(0.4,(_max_width*_pos_scl)/(_letters_str_w+0.1))
		
		var _letters_scl_2 = _letters_scl
		
		_letters_scl *= 1+(game_finished_flash2)

		_letters_str_w *= _letters_scl
		
		  
		
		if global.game_phase = 4 {
			
			draw_set_alpha(0.9)
			draw_set_color(_green_check_txt)
			

			draw_set_font(fnt_main)
			draw_text_transformed((global.sw/2)+(_length_str_w*-0.5),_panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12),string(_letters_str),_letters_scl*_tscl,_letters_scl*_tscl,0)
			
			if game_finished >= 1 {
				
				gpu_set_blendmode(bm_add)

				draw_set_alpha(0.5*(1-game_finished_fd2))
				draw_text_transformed((global.sw/2)+(_length_str_w*-0.5),_panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12),string(_letters_str),_letters_scl_2*_tscl*(1+(2*game_finished_fd2)),_letters_scl_2*_tscl*(1+(2*game_finished_fd2)),0)
			
				gpu_set_blendmode(bm_normal)
			
			}
			
		} else {
			
			
			_letters_str += "?"
			
			
			draw_set_alpha(0.6)
			draw_set_font(fnt_main_r)
			

		
			if global.game_hint_length_used = 1 {
				
				_length_str = " ("+string(_letters_str_l)+"/"+string(string_length(secret_word_str))
				
				if _str_diff > 0 {
					if global.light_mode = 0 {
						draw_set_color(make_color_hsv(36,150,250)) //yellow
					} else {
						draw_set_color(make_color_hsv(36,220,170)) //yellow
					}
				} else if _str_diff = 0 {
					
					if global.light_mode = 0 {
						draw_set_color(c_ltgray) //_green_check_txt)
					} else {
						draw_set_color(c_gray) //_green_check_txt)
					}
				} else {
					draw_set_color(make_color_hsv(250,190,250)) //red
					//_length_str += "!"
				}
				
				_length_str += ")"
				
				_length_str_w = string_width(_length_str)*_letters_scl*_tscl*0.45
				
				//_letters_str += " ("+string(string_length(secret_word_str))+")"
				draw_set_font(fnt_main_r)
				draw_text_transformed((global.sw/2)+(_letters_str_w*0.5)+(_length_str_w*0.0),_panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12),string(_length_str),_letters_scl*0.45*_tscl,_letters_scl*0.45*_tscl,0)
				
				if _str_diff < 0 {
				draw_set_font(fnt_main)
				draw_text_transformed((global.sw/2)+(_letters_str_w*0.5)+(_length_str_w*0.0)+(3*_scl),_panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12)+((-70+(2*pulse_2))*_letters_scl*_scl),"OVER!",_letters_scl*0.25*_tscl,_letters_scl*0.25*_tscl,0)
				}
				
			}
			
			
			draw_set_color(_c_white)
			draw_set_font(fnt_main)
			draw_text_transformed((global.sw/2)+(_length_str_w*-0.5),_panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12),string(_letters_str),_letters_scl*_tscl,_letters_scl*_tscl,0)
			
			
			
			
		}
		
		
	}
	
	draw_set_color(_c_white)
	
	
	if global.game_phase = 3 {
		draw_set_alpha(0.6)
		draw_set_font(fnt_main)
		
		//if global.game_hint_length_used = 1 {
		//	draw_set_color(make_color_hsv(36,150,250))
		//	draw_text_transformed(global.sw/2,(_panel_mid_y)+(-45*_scl),"length: "+string(string_length(secret_word_str)),0.15*_tscl,0.15*_tscl,0)
		//}
		
		draw_set_alpha(0.3)
		draw_set_font(fnt_main_r)
		draw_set_color(_c_white)
		
		if selected_word_length > 0 {
			if selected_word_length <= 3 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"too short",0.15*_tscl,0.15*_tscl,0)
			} else if selected_word_not_in_dictionary >= 1 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"not a valid word",0.15*_tscl,0.15*_tscl,0)
			} else if selected_word_already_guessed >= 1 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"already guessed",0.15*_tscl,0.15*_tscl,0)
			}
		}
	}
	//draw_text_transformed(global.sw/2,global.sh*0.8,"array:\n"+string(selected_word_array),0.12*_tscl,0.12*_tscl,0)
	
	
	draw_set_alpha(0.5)
	draw_set_valign(fa_bottom)
	draw_set_font(fnt_main)
	draw_set_color(_c_white)
	var _guesses_offset_y = 0
	
	var _guesses_str = " guesses"
	if guesses_count = 1 {_guesses_str = " guess"}
	
	var _score_total_str = ""
	
	if global.game_hints_used > 0 {
		var _hint_str = " hints"
		if global.game_hints_used = 1 {_hint_str = " hint"}
		_guesses_str += " (+"+string(global.game_hints_used)+string(_hint_str)+")"
	}
	
	if global.game_phase = 4 {
		
		draw_set_font(fnt_main)
		draw_set_alpha(0.5+(0.2*game_finished_fd2)+(-0.4*global.gave_up))
		
		_guesses_offset_y = -0*game_finished_fd2*_scl
		
		_guesses_str += " in "+string(scr_format_time(global.game_timer,0))
		
		//if global.game_score_guesses_and_hints >= 0 {
		//	_guesses_str += " = "+string(global.game_score_guesses_and_hints)+"pts"
		//}
		
		//if global.game_score_time_bonus >= 0 {
		//	_guesses_str += "\n+ "+string(global.game_score_time_bonus)+"pts time bonus ("+string(scr_format_time(global.game_timer,0))+")"
		//}
		
		//_guesses_str += "\n\n"
		
		if global.game_score_total >= 0 {
			_score_total_str += ""+string(global.game_score_total)+""
		} 
	}
	
	
	draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.36)+(_panel_ht*-0.28*game_finished_fd2)+(_guesses_offset_y),string(guesses_count)+string(_guesses_str),0.11*_tscl,0.11*_tscl,0)
	
	
	
	if obj_ctrlp.puzzle_is_unlimited != 1 {
		//score + leaderboard btn
		if global.game_phase = 4 {
		
			draw_set_alpha(0.8*game_finished_fd2)
			draw_set_font(fnt_main)
			draw_set_halign(fa_right)
			draw_set_valign(fa_middle)
			draw_set_color(_green_check_txt)
		
			if global.gave_up = 1 || global.game_score_total <= 0 {
				draw_set_color(_c_gray)
			}
			draw_text_transformed((global.sw/2)+(-59*_scl),(_panel_mid_y)+(_panel_ht*0.29)+(_panel_ht*-0.07*game_finished_fd2),string(_score_total_str),0.24*_tscl,0.24*_tscl,0)
			draw_text_transformed((global.sw/2)+(-30*_scl),(_panel_mid_y)+(_panel_ht*0.29)+(_panel_ht*-0.07*game_finished_fd2)+(-1*_scl),"pts",0.12*_tscl,0.12*_tscl,0)
	
	
			var _lb_btn_alp = 3
			var _lb_btn_col = _c_white
			if obj_ctrlp.lb_your_rank = -1 {
				_lb_btn_alp = 0.2
				_lb_btn_col = c_ltgray
			}
			draw_sprite_ext(spr_btn_2,0,global.sw/2+(65*_scl),(_panel_mid_y)+(_panel_ht*0.29)+(_panel_ht*-0.07*game_finished_fd2),(1)*(_scl*0.25),(1)*(_scl*0.25),0,_lb_btn_col,_lb_btn_alp*game_finished_fd2)
		
			if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
				if scr_mouse_over_button(global.sw/2+(65*_scl),(_panel_mid_y)+(_panel_ht*0.29)+(_panel_ht*-0.07*game_finished_fd2),
				0.31*_scl,0.0983*_scl) {
					show_debug_message("LB CLICKED")
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
					global.show_lb = 1
				}
			}
		
		}
	
	
		if global.game_phase = 4 {
	
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_set_font(fnt_main_r)
			draw_set_color(_c_white)
			draw_set_alpha(0.7*game_finished_fd)
	
			var _rank_str = ""
		
			if obj_ctrlp.lb_your_rank = -1 {
				draw_set_alpha(0.4*game_finished_fd2)
				_rank_str = "loading rank..."
			} else {
				_rank_str = $"rank {obj_ctrlp.lb_your_rank} of {obj_ctrlp.lb_total_players} - you scored higher than {obj_ctrlp.lb_your_percentile}% of players!"
			}

			draw_text_ext_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.39),_rank_str,160,3600,0.1*_tscl,0.1*_tscl,0)
		
		
		
		
			draw_set_valign(fa_middle)
			draw_set_font(fnt_main)
			draw_set_alpha(1)
		
		
		}
	
	} else {
		draw_set_alpha(0.8*game_finished_fd2)
		draw_set_font(fnt_main)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(_green_check_txt)
		
		if global.gave_up = 1 || global.game_score_total <= 0 {
			draw_set_color(_c_gray)
		}
		draw_text_transformed((global.sw/2)+(0*_scl),(_panel_mid_y)+(_panel_ht*0.34)+(_panel_ht*-0.07*game_finished_fd2),string(_score_total_str)+"pts",0.24*_tscl,0.24*_tscl,0)
		//draw_text_transformed((global.sw/2)+(10*_scl),(_panel_mid_y)+(_panel_ht*0.29)+(_panel_ht*-0.07*game_finished_fd2)+(-1*_scl),,0.12*_tscl,0.12*_tscl,0)
		
	}
	
	
	
	draw_set_valign(fa_top)
	draw_set_halign(fa_center)
	draw_set_font(fnt_main_r)
	draw_set_color(_c_white)
	draw_set_alpha(0.3)
	
	var _guess_list_str = ""
	if global.game_phase = 4 {
		//_guess_list_str = "GUESSES: "
	}
	
	for (var i = 1; i < array_length(guesses_list); ++i) {
		_guess_list_str += guesses_list[i]
		if i < array_length(guesses_list)-1 {
			_guess_list_str += ", "
		}
	}
	
	//_guess_list_str += _guess_list_str
	
	if global.game_phase = 4 {
		//don't show guess list on end screen
	} else {
		draw_text_ext_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.4),string(_guess_list_str),160,3600,0.1*_tscl,0.1*_tscl,0)
	}
	
	
	if global.game_phase = 4 { //stats
	
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		draw_set_color(c_black)
		draw_set_alpha(0.15*game_finished_fd)
		if global.light_mode = 1 {
			draw_set_color(c_white)	
			draw_set_alpha(0.45*game_finished_fd)
		}
		
		
		var _stat_h = 50
		var _stat_y = 0.7+((1-game_finished_fd)*-0.2)
		
		var _stat_sw = 225
		var _stat_sw_1 = 225
		if global.is_landscape {
			_stat_sw = 450	
		}
		
		
		//bg
		draw_rectangle(
		(global.sw/2)+(-_stat_sw*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+(-_stat_h*_scl),
		(global.sw/2)+ (_stat_sw*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+(_stat_h*_scl),0)
		draw_rectangle(
		(global.sw/2)+(-_stat_sw*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-_stat_h+4)*_scl),
		(global.sw/2)+ (_stat_sw*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+-4)*_scl),0)
	
		draw_set_color(_c_white)
		draw_set_alpha(0.5*game_finished_fd)
		draw_set_font(fnt_main)
		var _stats_title_str = "- Your Daily Stats -"
		if obj_ctrlp.puzzle_is_daily != 1 {
			_stats_title_str = "- Your Unlimited Stats -"
		}
		
		
		draw_text_transformed((global.sw/2)+(0*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-_stat_h+17)*_scl),_stats_title_str,0.1*_tscl,0.1*_tscl,0)

		var _stat_str
		_stat_str[1][1] = "played"
		_stat_str[2][1] = "finished"
		_stat_str[3][1] = "avg guesses"
		_stat_str[4][1] = "avg time"
		_stat_str[5][1] = "avg score"


		if obj_ctrlp.puzzle_is_daily != 1 {
			_stat_str[1][2] = obj_ctrlp.stat_u_total_started //"25"
			_stat_str[2][2] = obj_ctrlp.stat_u_total_finished_perc //"95%"
			_stat_str[3][2] = obj_ctrlp.stat_u_total_guesses_avg //"3.2"
			_stat_str[4][2] = obj_ctrlp.stat_u_total_time_avg //"1:24"
			_stat_str[5][2] = obj_ctrlp.stat_u_total_score_avg //"652"
		} else {
			_stat_str[1][2] = obj_ctrlp.stat_d_total_started //"25"
			_stat_str[2][2] = obj_ctrlp.stat_d_total_finished_perc //"95%"
			_stat_str[3][2] = obj_ctrlp.stat_d_total_guesses_avg //"3.2"
			_stat_str[4][2] = obj_ctrlp.stat_d_total_time_avg //"1:24"
			_stat_str[5][2] = obj_ctrlp.stat_d_total_score_avg //"652"
		}
			
		
		draw_set_alpha(0.7*game_finished_fd)
		draw_set_font(fnt_main_r)
		draw_text_transformed((global.sw/2)+(-0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[1][1],		0.08*_tscl,0.08*_tscl,0)
		draw_text_transformed((global.sw/2)+(-0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[2][1],		0.08*_tscl,0.08*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.00*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[3][1],		0.08*_tscl,0.08*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[4][1],		0.08*_tscl,0.08*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[5][1],		0.08*_tscl,0.08*_tscl,0)
		
		draw_set_alpha(0.5*game_finished_fd)
		draw_set_font(fnt_main)
		draw_text_transformed((global.sw/2)+(-0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[1][2],		0.19*_tscl,0.19*_tscl,0)
		draw_text_transformed((global.sw/2)+(-0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[2][2],		0.19*_tscl,0.19*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.00*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[3][2],		0.19*_tscl,0.19*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[4][2],		0.19*_tscl,0.19*_tscl,0)
		draw_text_transformed((global.sw/2)+( 0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[5][2],		0.19*_tscl,0.19*_tscl,0)
		
	
	}
	
	
	if global.game_phase = 4 {
	
		draw_set_valign(fa_middle)
		draw_set_font(fnt_main)
		draw_set_alpha(1)
		

		
		if game_finished_fd > 0 {
			
			if obj_ctrlp.puzzle_is_daily = 1 {

				var _yest_btn_enabled = 0
				if obj_ctrlp.daily_prev_postId != "-9999" {
					_yest_btn_enabled = 1	
				}
			
				draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,35+100*_yest_btn_enabled),3*game_finished_fd)
				draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
			
				draw_sprite_ext(spr_btn,3,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,3,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
			
				if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
					if scr_mouse_over_button(global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.39*_scl,0.12*_scl) {
						show_debug_message("BTN 1 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						//play previous
						if obj_ctrlp.daily_prev_postId != "-9999" {
					
							scr_reddit_reset_post()

							//load prev id
							scr_reddit_load_post(obj_ctrlp.daily_prev_postId)
				
						} else {
							show_debug_message("no obj_ctrlp.daily_prev_postId")
						}
					
					}
				
					if scr_mouse_over_button(global.sw/2+(110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.39*_scl,0.12*_scl) {
						show_debug_message("BTN 2 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						if 1 = 1 { //go to main menu
							obj_ctrlp.already_finished = 0 //reset this so that puzzles don't auto complete moving forward	
							obj_ctrlp.daily_prev_postId = "-9999"
							obj_ctrlp.daily_next_postId = "-9999"
						
							scr_reddit_reset_post()
							room_restart()	
						}
					}
				}
			
			} else {
				
				var _yest_btn_enabled = 1
			
				draw_sprite_ext(spr_btn,1,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,35+100*_yest_btn_enabled),3*game_finished_fd)
				draw_sprite_ext(spr_btn,1,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
			
				draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
			
				if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
					if scr_mouse_over_button(global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.39*_scl,0.12*_scl) {
						show_debug_message("BTN 1 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						//play previous
						show_debug_message("PLAY ANOTHER!")
			
						show_debug_message("NEW LETTERS")
			
						var _event_struct = { //
							screen_name: "NewLetters"+string(global.game_grid_size),
						};
						GoogHit("screen_view",_event_struct)
			
						scr_reddit_reset_post()
						scr_board_reset_defs()

			
						global.game_phase = 3
			
						//global.game_grid_size = 6
						//global.game_grid_size_sqr = sqr(global.game_grid_size)
						global.am_creating = 0
						global.skip_create = 1
						global.am_generate_random = 1
						var _event_struct = { //
							screen_name: "RandomAnother",
						};
						GoogHit("screen_view",_event_struct)
						
						
						with (obj_ctrlp) {
							if level_status = LEVEL_STATUS_NotStarted { //make sure profile started stat gets updated if insta giveup
								level_status = LEVEL_STATUS_Started
								if puzzle_is_daily = 1 {
									stat_d_total_started = string(real(stat_d_total_started)+1)
								} else {
									stat_u_total_started = string(real(stat_u_total_started)+1)	
								}
							}
						}
						
						scr_board_init()
					
					}
				
					if scr_mouse_over_button(global.sw/2+(110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.39*_scl,0.12*_scl) {
						show_debug_message("BTN 2 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						if 1 = 1 { //go to main menu
							obj_ctrlp.already_finished = 0 //reset this so that puzzles don't auto complete moving forward	
							obj_ctrlp.daily_prev_postId = "-9999"
							obj_ctrlp.daily_next_postId = "-9999"
						
							scr_reddit_reset_post()
							room_restart()	
						}
					}
				}
				
			}
			
		}
	
	}
	
	
	
	
	
	
	draw_set_valign(fa_middle)
	draw_set_font(fnt_main)
	draw_set_alpha(1)
	
} 


/////////////////


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
		draw_set_color(_c_white)
		
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
		draw_set_color(_c_white)
	}	
}


draw_set_alpha(1)
//draw_text_transformed(global.sw*0.1,25*_pos_scl,"phase "+string(global.game_phase),0.1*_tscl,0.1*_tscl,0)

//top left menu
draw_set_font(fnt_main)
draw_set_alpha(0.6)

//if global.game_phase >= 1 {
////draw_sprite_ext(spr_btn_3,0,global.sw*0.1,_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
////draw_text_transformed(global.sw*0.1,_nav_mid_y,"menu",0.12*_tscl,0.12*_tscl,0)
//}

if 1=1 {//global.game_phase >= 3 {
	
	draw_set_alpha(0.6)
	var _sscl = 0.12
	draw_set_font(fnt_main)
	
	
	//top right btn
	//draw_sprite_ext(spr_btn_3,2,global.sw*0.9,_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)

	//if global.game_phase >= 4 {
	//	draw_set_alpha(0.8*(0.8+(0.4*(sin(obj_ctrl.timey*0.08)))))
	//	_sscl = 0.12*(1+(0.1*(sin(obj_ctrl.timey*0.08))))
	//	draw_text_transformed(global.sw*0.9,_nav_mid_y,"share",_sscl*_tscl,_sscl*_tscl,0)
	//	//draw_sprite_ext(spr_sqr512,0,global.sw*0.9,_nav_mid_y,1.2*_sscl*_tscl,0.6*_sscl*_tscl,0,make_color_hsv(100,255,210),draw_get_alpha()*1.2)
	//} else {
	//	draw_set_alpha(0.6)
	//	_sscl = 0.1
	//	draw_text_transformed(global.sw*0.9,_nav_mid_y,"how to",_sscl*_tscl,_sscl*_tscl,0)	
	//}
	
	draw_sprite_ext(spr_btn_5,1,(global.sw*1)+((20+5)*-_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	draw_sprite_ext(spr_btn_5,2,(global.sw*1)+((20+5+40+5)*-_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	
	if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			
		if scr_mouse_over_button((global.sw*1)+((20+5)*-_scl),_nav_mid_y,
		0.083*_scl,0.0983*_scl) {
			show_debug_message("HELP CLICKED")
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.show_howto = 1
		}
			
		if scr_mouse_over_button((global.sw*1)+((20+5+40+5)*-_scl),_nav_mid_y,
		0.083*_scl,0.0983*_scl) {
			show_debug_message("options CLICKED")
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.show_options = 1
			obj_ctrlp.clear_stats_confirm = 0 //reset
		}
			
	}
	
}
	
	
if global.game_phase >= 3 {
	
	draw_set_alpha(0.6)
	var _sscl = 0.12
	draw_set_font(fnt_main)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.6)
	
	
	var _level_name = obj_ctrlp.postData_levelName
	//_level_name = "Daily Sneakle #32"
	//obj_ctrlp.postData_levelTag = "daily"
	
	if obj_ctrlp.puzzle_is_daily = 1 {
		_level_name = string_digits(_level_name)
		_level_name = "DAILY #"+_level_name
	} else if obj_ctrlp.puzzle_is_community = 1 || obj_ctrlp.puzzle_is_special = 1 {
		//
	} else if obj_ctrlp.puzzle_is_unlimited = 1 {
		_level_name = "UNLIMITED "+string(global.game_grid_size)+"x"+string(global.game_grid_size)
	}
	
	if _level_name != "" {
		draw_text_transformed(global.sw*0.5,_nav_mid_y+(1*_scl),_level_name,0.1*_tscl,0.1*_tscl,0)
	}
	
	
	//prev next btns
	
	if obj_ctrlp.puzzle_is_daily = 1 {
	
		var _level_name_w = string_width(_level_name)*0.1
		var _prev_btn_enabled = 0
		var _next_btn_enabled = 0
	
		if obj_ctrlp.daily_prev_postId != "-9999" {
			_prev_btn_enabled = 1	
		}
		if obj_ctrlp.daily_next_postId != "-9999" {
			_next_btn_enabled = 1	
		}
	
		draw_sprite_ext(spr_btn_4,2,(global.sw*0.5)+(_level_name_w*0.5*-_scl)+(30*-_scl),_nav_mid_y,-0.25*_scl,0.25*_scl,0,make_colour_hsv(0,0,155+100*_prev_btn_enabled),0.4+(_prev_btn_enabled))

		draw_sprite_ext(spr_btn_4,2,(global.sw*0.5)+(_level_name_w*0.5*_scl)+(30*_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(0,0,155+100*_next_btn_enabled),0.4+(_next_btn_enabled))


		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			
			if scr_mouse_over_button((global.sw*0.5)+(_level_name_w*0.5*-_scl)+(30*-_scl),_nav_mid_y,
			0.06*_scl,0.0983*_scl) {
				show_debug_message("PREV CLICKED")
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
				if obj_ctrlp.daily_prev_postId != "-9999" {
					
					scr_reddit_reset_post()

					//load prev id
					scr_reddit_load_post(obj_ctrlp.daily_prev_postId)
				
				} else {
					show_debug_message("no obj_ctrlp.daily_prev_postId")
				}

			}
			
			if scr_mouse_over_button((global.sw*0.5)+(_level_name_w*0.5*_scl)+(30*_scl),_nav_mid_y,
			0.06*_scl,0.0983*_scl) {
				show_debug_message("NEXT CLICKED")
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
				if obj_ctrlp.daily_next_postId != "-9999" {
					
					scr_reddit_reset_post()

					//load prev id
					scr_reddit_load_post(obj_ctrlp.daily_next_postId)
				
				} else {
					show_debug_message("no obj_ctrlp.daily_next_postId")
				}
			}
			
		}

	}
	
	
	if global.game_phase < 4 {
		
		draw_set_font(fnt_main)
		
		//btn bgs
		//draw_sprite_stretched_ext(spr_sqr512,2,(global.sw*0.1)-(0.18*_tscl*256),gui_footer_mid_y-(0.12*_tscl*256),0.18*_tscl*512,0.12*_tscl*512,_c_white,0.2) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.1,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.9,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		
		
		draw_sprite_ext(spr_btn_3,2,global.sw*0.1,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)

		draw_set_alpha(0.6)
		draw_text_transformed(global.sw*0.1,gui_footer_mid_y,"give up",0.12*_tscl,0.12*_tscl,0)
		
		
		
		if global.game_hint_letter_used < string_length(secret_word_str) {
			draw_set_alpha(0.6)
		} else {
			draw_set_alpha(0.1)
		}
		
		draw_sprite_ext(spr_btn_3,2,global.sw*0.9,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)

		draw_text_transformed(global.sw*0.9,gui_footer_mid_y,"hint?",0.12*_tscl,0.12*_tscl,0)
		
	} else if global.game_phase = 4 {
		
		draw_set_alpha(0.6)
		
		//btn bgs
		//draw_sprite_stretched_ext(spr_sqr512,2,(global.sw*0.1)-(0.18*_tscl*256),gui_footer_mid_y-(0.12*_tscl*256),0.18*_tscl*512,0.12*_tscl*512,_c_white,0.2) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.1,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.02) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.9,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		
		//draw_text_transformed(global.sw*0.1,gui_footer_mid_y,"play\nanother",0.12*_tscl,0.12*_tscl,0)
	}

}

draw_set_alpha(1)



//for (var i = 1; i <= global.game_grid_size_sqr; ++i) {
//   //draw_text_transformed(global.tile_letter[i].x,global.tile_letter[i].y,i,0.2,0.2,0)
//}



//if selected_word_length > 0 {
//	for (var l = 0; l < selected_word_length; ++l) {
//		//draw_line_width(selected_word_array[l]
//	}	
//}


//if keyboard_check(vk_control) {
//	draw_set_alpha(1)
//	draw_set_color(c_aqua)
//	draw_text_transformed(device_mouse_x_to_gui(0)*global.pr,device_mouse_y_to_gui(0)*global.pr,string(device_mouse_x_to_gui(0)*global.pr)+","+string(device_mouse_y_to_gui(0)*global.pr),0.1*_tscl,0.1*_tscl,0)
	
	
//	draw_circle(0,0,50,1)
//	draw_circle(global.sw,global.sh,50,1)
	
	
	
//	draw_set_color(_c_white)
//}

//gpu_set_blendmode(bm_add)
//draw_set_alpha(0.05)
//draw_rectangle_color(0,global.sh*0.7,global.sw,global.sh,c_black,c_black,_c_white,_c_white,0)
//draw_set_alpha(1)
//gpu_set_blendmode(bm_normal)





draw_set_valign(fa_middle)
draw_set_halign(fa_middle)
draw_set_font(fnt_main_r)
draw_set_alpha(1)
draw_set_colour(_c_white)



if keyboard_check(vk_shift) {
	draw_set_alpha(0.3)
	draw_text_transformed(global.sw*0.5,(global.sh*1)-(50*_pos_scl),global.current_copy_code,0.07*_tscl,0.07*_tscl,0)
}



draw_set_font(fnt_main_r)

if global.game_phase <= 0 {
	var _version_scl = 1
	if global.game_phase <= 0 {
		_version_scl = 1.5
	}
	draw_set_font(fnt_main)
	draw_set_alpha(0.5*_version_scl)
	draw_text_transformed(global.sw*0.5,(global.sh*1)+(-50*_version_scl*_scl),"<3 @FermenterGames",0.1*_version_scl*_tscl,0.1*_version_scl*_tscl,0)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.2*_version_scl)
	draw_text_transformed(global.sw*0.5,(global.sh*1)+(-50*_version_scl*_scl),"\n\n\n"+date_datetime_string(GM_build_date),0.07*_version_scl*_tscl,0.07*_version_scl*_tscl,0)
	
	//draw_text_transformed(global.sw*0.5,(global.sh*1)+(-50*_version_scl*_scl),"\n\n\n"+string(global.sw)+"x"+string(global.sh),0.07*_version_scl*_tscl,0.07*_version_scl*_tscl,0)
}

if global.game_phase = 3 {
	if obj_ctrlp.option_show_timer = 1 {
		draw_set_font(fnt_main_r)
		draw_set_alpha(0.3)
		draw_text_transformed(global.sw*0.5,gui_footer_mid_y,scr_format_time(global.game_timer,0),0.12*_tscl,0.12*_tscl,0)
	}
}



draw_set_font(fnt_main)

draw_set_alpha(1)



if global.show_input_prompt = 1 {
	
	draw_set_alpha(0.7*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
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
	
	draw_set_alpha(0.7*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
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
	
	draw_set_alpha(0.7*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
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

//leaderboard
if global.show_lb_fd > 0 {
	
	draw_set_alpha(0.95*global.show_lb_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
	scr_leaderboard_list_draw(global.sw*0.5,global.sh*0.1,0,0,0.33,1*global.show_lb_fd,0)
	
	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_lb_fd) 
		
	
	if mouse_check_button_pressed(mb_left) && global.show_lb_fd > 0.5 {
		audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
		html_submit_closebtn()
	}
	
}

//how to
if global.show_howto_fd > 0 {
	
	draw_set_alpha(0.95*global.show_howto_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	

	draw_sprite_ext(spr_howto,0,global.sw/2,(global.sh/2)+(40*_scl*(1-global.show_howto_fd)),0.55*_scl,0.55*_scl,0,c_white,-1+(2*global.show_howto_fd)) 
		

	
	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_howto_fd) 
		
	
	if mouse_check_button_pressed(mb_left) && global.show_howto_fd > 0.5 {
		audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
		html_submit_closebtn()
		global.show_howto = 0
	}
	
}



//options
if global.show_options_fd > 0 {
	
	draw_set_alpha(0.95*global.show_options_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	

	//draw_sprite_ext(spr_howto,0,global.sw/2,(global.sh/2)+(40*_scl*(1-global.show_options_fd)),0.55*_scl,0.55*_scl,0,_c_white,-1+(2*global.show_options_fd)) 
		
	
	
	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_options_fd) 
	
	draw_set_color(_c_white)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_middle)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.7*global.show_options_fd)
	draw_text_transformed(global.sw*0.5,(global.sh*0)+(80*_scl),"options",0.2*_tscl,0.2*_tscl,0)
	
	draw_set_alpha(0.3*global.show_options_fd)
	//draw_text_transformed(global.sw*0.5,(global.sh*0)+(140*_scl),"in development :)",0.15*_tscl,0.15*_tscl,0)
	
	//sep line
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(130*_scl),0.65*_scl,0.004*_scl,0,_c_white,0.2*global.show_options_fd) 
	
	
	var _op_b_1_si = 0
	var _op_b_1_str = "DARK MODE"
	var _op_b_2_si = 2
	var _op_b_3_si = 3
	var _op_b_3_col = c_white
	var _op_b_3_col2 = _c_gray
	
	if global.light_mode = 0 {
		_op_b_1_str = "LIGHT MODE"
	}
	
	//obj_ctrlp.option_show_timer = 0
	if obj_ctrlp.option_show_timer = 1 {
		_op_b_2_si = 1
	}
	
	
	if obj_ctrlp.clear_stats_confirm = 1 {
		_op_b_3_si = 4
		_op_b_3_col = c_red
		_op_b_3_col2 = c_maroon
		
	} else if obj_ctrlp.clear_stats_confirm = -1 {
		_op_b_3_si = 2
		_op_b_3_col = c_dkgray
		_op_b_3_col2 = c_dkgray
	}
	
	
	draw_set_color(c_white)
	//btn1
	draw_sprite_ext(spr_btn_8,_op_b_1_si,global.sw*0.5,(200*_scl)+(60*_scl*0)+(5*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_1_si,global.sw*0.5,(200*_scl)+(60*_scl*0),0.25*_scl,0.25*_scl,0,c_white,2*global.show_options_fd)
	
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_options_fd)
	draw_text_transformed(global.sw*0.5,(200*_scl)+(60*_scl*0),_op_b_1_str,0.11*_tscl,0.11*_tscl,0)
	
	
	//btn2
	draw_sprite_ext(spr_btn_8,_op_b_2_si,global.sw*0.5,(200*_scl)+(60*_scl*1)+(5*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_2_si,global.sw*0.5,(200*_scl)+(60*_scl*1),0.25*_scl,0.25*_scl,0,c_white,2*global.show_options_fd)
	
	//btn3
	draw_sprite_ext(spr_btn_8,_op_b_3_si,global.sw*0.5,(200*_scl)+(60*_scl*2)+(5*_scl),0.25*_scl,0.25*_scl,0,_op_b_3_col2,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_3_si,global.sw*0.5,(200*_scl)+(60*_scl*2),0.25*_scl,0.25*_scl,0,_op_b_3_col,2*global.show_options_fd) 
	
	
	if global.show_options_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
		if scr_mouse_over_button(global.sw+(-40*_scl),(40*_scl),0.2*_scl,0.1*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			//close
			html_submit_closebtn()
			global.show_options = 0
			
		}
		
		if scr_mouse_over_button(global.sw+(-40*_scl),global.sh-(40*_scl),0.2*_scl,0.1*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.show_debug = !global.show_debug
		}
		
		if scr_mouse_over_button(global.sw*0.5,(200*_scl)+(60*_scl*0),0.64*_scl,0.08*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//btn1
			
			global.light_mode = !global.light_mode
		}
		
		if scr_mouse_over_button(global.sw*0.5,(200*_scl)+(60*_scl*1),0.64*_scl,0.08*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//btn1
			
			if obj_ctrlp.option_show_timer = 0 {
				obj_ctrlp.option_show_timer = 1	
			} else if obj_ctrlp.option_show_timer = 1 {
				obj_ctrlp.option_show_timer = 0
			}
		}
		
		if scr_mouse_over_button(global.sw*0.5,(200*_scl)+(60*_scl*2),0.64*_scl,0.08*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//btn2
			if obj_ctrlp.clear_stats_confirm = 0 {
				obj_ctrlp.clear_stats_confirm = 1	
			} else if obj_ctrlp.clear_stats_confirm = 1 {
				obj_ctrlp.clear_stats_confirm = -1
				
				
				show_debug_message("reset player stats to 0 from options")
			
				with (obj_ctrlp) {
					
					stat_d_total_started		= "0"
					stat_d_total_finished	= "0"
					stat_d_total_gaveup		= "0"
					stat_d_total_score		= "0"
					stat_d_total_time			= "0"
					stat_d_total_guesses		= "0"
					stat_d_total_hints		= "0"

					stat_u_total_started		= "0"
					stat_u_total_finished	= "0"
					stat_u_total_gaveup		= "0"
					stat_u_total_score		= "0"
					stat_u_total_time			= "0"
					stat_u_total_guesses		= "0"
					stat_u_total_hints		= "0"
					
					stat_d_total_finished_perc = "0"
					stat_d_total_score_avg = "0"
					stat_d_total_time_avg =	"0"
					stat_d_total_guesses_avg = "0"

					stat_u_total_finished_perc = "0%"
					stat_u_total_score_avg = "0"
					stat_u_total_time_avg =	"0"
					stat_u_total_guesses_avg = "0"
					
					api_save_profile({
						stat_d_total_started,
						stat_d_total_finished,
						stat_d_total_gaveup,
						stat_d_total_score,
						stat_d_total_time,
						stat_d_total_guesses,
						stat_d_total_hints,
						stat_u_total_started,
						stat_u_total_finished,
						stat_u_total_gaveup,
						stat_u_total_score,
						stat_u_total_time,
						stat_u_total_guesses,
						stat_u_total_hints
					}, function(_status, _ok, _result) {
						//alarm[4] = 60;
					});
				}
			}
		}
	}
}


//show_submitting_post
if global.show_submitting_post > 0 {
	
	draw_set_alpha(0.95*global.show_submitting_post)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	


	draw_set_alpha(0.3*ctrl_fd)
	draw_set_font(fnt_main)
	draw_set_color(_c_white)
	
	
	if global.show_submitting_post = 1 {
		draw_text_transformed(global.sw*0.5,global.sh*0.5,"submitting\nyour puzzle...",0.13*_tscl*ctrl_fd,0.13*_tscl*ctrl_fd,0)
	} else if global.show_submitting_post = 2 {
		draw_text_transformed(global.sw*0.5,global.sh*0.5,"redirecting\nto new post!",0.13*_tscl*ctrl_fd,0.13*_tscl*ctrl_fd,0)
	}
	
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.5,0.4*_scl*ctrl_fd,0.4*_scl*ctrl_fd,global.game_timer_meta*1,_c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.5,0.5*_scl*ctrl_fd,0.5*_scl*ctrl_fd,global.game_timer_meta*-0.88,_c_white,0.06)
		

	
}



if global.game_loading >= 1 { //loading
	
	//nav menu top
	if global.game_phase > 0 {
		draw_set_alpha(0.9*ctrl_fd)
		draw_set_color(_overlay_blue)
		draw_rectangle(0,0,global.sw,global.sh,0)
	}
		
	draw_set_alpha(0.3*ctrl_fd)
	draw_set_font(fnt_main)
	draw_set_color(_c_white)
	
	
		
	draw_text_transformed(global.sw*0.5,global.sh*0.5,"loading...",0.13*_tscl*ctrl_fd,0.13*_tscl*ctrl_fd,0)
		
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.5,0.4*_scl*ctrl_fd,0.4*_scl*ctrl_fd,global.game_timer_meta*1,_c_white,0.06)
	draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,global.sh*0.5,0.5*_scl*ctrl_fd,0.5*_scl*ctrl_fd,global.game_timer_meta*-0.88,_c_white,0.06)
		
}


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
//	border_col = merge_color(image_blend,_c_white,0.3)
//	letter_col = _c_white//merge_color(image_blend,_c_white,0.7)
//	//letter_col = merge_color(letter_col,_c_white,am_selected_fd)

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
//	//.blend(_c_white, draw_get_alpha())
//	//.align(fa_center, fa_middle)
//	//.transform(2.5*scl,2.5*scl,image_angle)
//	//.draw(x+lengthdir_x(-4+(50*scl),image_angle-90),y+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)

//	draw_set_alpha(lerp(0.6,1,clamp(am_selected_fd+am_clued_fd,0,1)))
//	draw_set_color(letter_col)//merge_color(letter_col,_c_white,am_selected_fd))
//	draw_set_color(merge_color(letter_col,_c_white,am_selected_fd))

//	var _text_offset_y = -20//20
//	var _text_scl = my_text_scl*scl //20

//	draw_text_transformed(x+lengthdir_x(-_tile_ht+(_text_offset_y*scl),image_angle-90),y+lengthdir_y(-_tile_ht+(_text_offset_y*scl),image_angle-90)+_spawn_slam,string_lower(my_letter_str),_text_scl,_text_scl,image_angle)

//	draw_set_color(_c_white)

//	//if global.game_phase = 3 && 1=0 {
	
//	//	scribble(am_exed)
//	//	//.scale_to_box(-1, 650*_pos_scl, -1)
//	//	.line_spacing("55%")
//	//	.starting_format(font_get_name(draw_get_font()), letter_col)
//	//	.blend(_c_white, draw_get_alpha()*0.7)
//	//	.align(fa_center, fa_middle)
//	//	.transform(1*scl,1*scl,image_angle)
//	//	.draw(x+22+lengthdir_x(-4+(50*scl),image_angle-90),y+15+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)


//	//	scribble(am_clued)
//	//	//.scale_to_box(-1, 650*_pos_scl, -1)
//	//	.line_spacing("55%")
//	//	.starting_format(font_get_name(draw_get_font()), letter_col)
//	//	.blend(_c_white, draw_get_alpha()*0.7)
//	//	.align(fa_center, fa_middle)
//	//	.transform(1*scl,1*scl,image_angle)
//	//	.draw(x-22+lengthdir_x(-4+(50*scl),image_angle-90),y+15+lengthdir_y(-4+(50*scl),image_angle-90)+_spawn_slam)

//	//}

//	if am_exed = 1 && am_selected <= 0 {
//	//exed
//	draw_sprite_ext(spr_sqr512,4,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*0.8,image_yscale*0.8,image_angle+45,letter_col,image_alpha*1)

//	}
	
//}

draw_set_font(fnt_main)

//draw_set_alpha(1)
//draw_set_color(_c_white)

//draw_set_halign(fa_left)
//draw_set_valign(fa_top)
//draw_text_ext_transformed(global.sw*0.1, global.sh*0.1, $"game_finished_fd: {game_finished_fd}\ngame_finished_delay: {game_finished_delay}", 140, 2000,0.1*_tscl,0.1*_tscl,0)

//draw_set_halign(fa_center)
//draw_set_valign(fa_middle)


if keyboard_check(vk_control) || global.show_debug = 1 {
	draw_set_font(fnt_main)

	draw_set_alpha(1)
	draw_set_color(_c_white)

	draw_set_halign(fa_left)
	draw_set_valign(fa_top)

	//{"top":[{"username":"FermenterGames","score":3.0,"rank":1.0}],"me":{"username":"FermenterGames","score":3.0,"rank":1.0},"totalPlayers":1.0,"generatedAt":1768893303014.0}

	var _lb_str = ""
	if obj_ctrlp.lb_json != undefined {
		if obj_ctrlp.lb_json.totalPlayers >= 1 {
			_lb_str = $"lb_json.top[0].rank: {obj_ctrlp.lb_json.top[0].rank}\nlb_json.me.rank: {obj_ctrlp.lb_json.me.rank}\nLEADERBOARD: {obj_ctrlp.lb_json_stringified}\n"
		} else {
			_lb_str = $"LEADERBOARD empty"
		}
	}


	var _postData_str = ""
	if 1=1 {//obj_ctrlp.postData != undefined {
	
		_postData_str = $"loading_postdata_stage: {obj_ctrlp.loading_postdata_stage}\nloading_postdata_info: {string(obj_ctrlp.loading_postdata_info)}\npostId: {obj_ctrlp.postId} (orig: {obj_ctrlp.postId_orig})\npostData_levelName: {obj_ctrlp.postData_levelName}\npostData_gameData: {obj_ctrlp.postData_gameData}\npostData_str: {obj_ctrlp.postData_str}\n"
	}
	
	//var _profile_str = ""
	
	//if 

	draw_set_halign(fa_left)
	draw_text_ext_transformed(global.sw*0.1, global.sh*0.1, $"User: {obj_ctrlp.username}\nscore_guesses: {obj_ctrlp.score_guesses}\nscore_hints: {obj_ctrlp.score_hints}\nscore_time: {obj_ctrlp.score_time}\nscore_combined: {obj_ctrlp.score_combined}\n\n\nSTATS\nstarted: {obj_ctrlp.stat_d_total_started}\nfinished: {obj_ctrlp.stat_d_total_finished}\nguesses: {obj_ctrlp.stat_d_total_guesses}\nscore: {obj_ctrlp.stat_d_total_score}\n\n\n"+string(_postData_str), 140, 2000,0.1*_tscl,0.1*_tscl,0)

	if _lb_str != "" {
		draw_set_halign(fa_right)
		draw_text_ext_transformed(global.sw*0.9, global.sh*0.1,string(_lb_str), 140, 2000,0.1*_tscl,0.1*_tscl,0)
	}

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)	
}

