if (live_call()) return live_result;

//if (global.show_any_modal >= 1) {
//   io_clear(); // Clears all input states for this specific frame/step
//}

gpu_set_tex_filter(true)

var _pos_scl = gui_pos_scl
var _scl = gui_sz_scl
var _tscl = gui_txt_scl *ctrl_fd

var _panel_bottom_y = gui_panel_bottom_y
var _panel_top_y = gui_panel_top_y
var _panel_mid_y = gui_panel_mid_y
var _nav_mid_y = gui_nav_mid_y

var _panel_ht = abs(_panel_bottom_y-_panel_top_y)


var _highlight_blue = make_color_hsv(145,180,140)
var _overlay_blue = make_color_hsv(145,120,20)
var _overlay_blue_dk = _overlay_blue
var _green_check_col = make_color_hsv(100,255,210)
var _green_check_txt = make_color_hsv(100,215,250)

var _c_gray = c_gray
var _c_white = c_white //rgb(255,96,96)

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

//obj_ctrlp.profile_joined = 1

if global.game_phase != 0 { //&& obj_ctrlp.profile_joined >= 1 {
	
	var _nav_logo_col = _c_white
	var _nav_logo_alp = 0.7
	if global.light_mode = 1 {
		_nav_logo_col = _highlight_blue
		_nav_logo_alp = 0.9
	}
	//draw_sprite_ext(spr_sneakle_logo,0,(global.sw*0.0)+(20*_scl),_nav_mid_y,0.08*_tscl,0.08*_tscl,0,_nav_logo_col,_nav_logo_alp*0.2) 

	draw_sprite_ext(spr_sneakle_logo,0,(global.sw*0.0)+(32*_scl),_nav_mid_y,0.07*_tscl,0.07*_tscl,0,_nav_logo_col,_nav_logo_alp) 

	draw_sprite_ext(spr_btn_ham,0,(global.sw*0)+((0)*-_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1)

}




//join r/sneakle btn
if 1=1 {
	
	//obj_ctrlp.profile_joined = 0
	
	if real(obj_ctrlp.profile_joined) <= 0 && global.am_creating = 0 && global.game_loading <= 0 {
		
		//1
		
		join_btn_on[1] = 0
		if game_finished_fd2 <= 0.1 {
			join_btn_on[1] = 1
		}
		join_btn_pos[1,0] = (global.sw*1)+(-10*_scl)+((-37+(-15*game_finished_fd2))*_scl)
		join_btn_pos[1,1] = _nav_mid_y+((38+(12*game_finished_fd2))*_scl)
		join_btn_scl[1] = 1
		
		if global.game_phase = 0 {
			join_btn_pos[1,0] = (global.sw*0)+(10*_scl)+((55)*_scl)
			join_btn_pos[1,1] = _nav_mid_y+((2)*_scl)
			join_btn_scl[1] = 1.5
		}
	
		var _join_si = 0
		var _join_alp = 1
		
		var _glow_amt = 0//game_finished_fd2
		if global.game_phase = 0 {
			_glow_amt = 1	
		}
		
		if obj_ctrlp.profile_joined = "-0.1" {
			_join_alp *= 0.4
			_glow_amt *= 0.1
		}
	
		if _glow_amt > 0 {
			_join_si = 1
			gpu_set_blendmode(bm_add)
			draw_sprite_ext(spr_circ_grad512,0,join_btn_pos[1,0],join_btn_pos[1,1],0.8*_scl*(0.5)*pulse_5*(1+(0.1*-pulse_1*_glow_amt)),0.4*_scl*(0.5)*pulse_5*(1+(0.1*pulse_1*_glow_amt)),0,_highlight_blue,1*_glow_amt*pulse_5)
			//draw_sprite_ext(spr_join_sneakle,1,(global.sw*0.0)+(20*_scl)+(47*_scl),_nav_mid_y+(0*_scl),0.3*_scl*(1)*pulse_5,0.3*_scl*(1)*pulse_5,0,c_white,1*game_finished_fd2*pulse_5)
	
			draw_sprite_ext(spr_join_sneakle,2,join_btn_pos[1,0],join_btn_pos[1,1],(0.22+(0.1*_glow_amt))*_scl*(1.1+(0.03*-pulse_1*_glow_amt)),(0.22+(0.1*_glow_amt))*_scl*(1.1+(0.03*pulse_1*_glow_amt)),0,make_colour_hsv(25,200,255),0.5*_glow_amt)

	
			gpu_set_blendmode(bm_normal)
		}

		draw_sprite_ext(spr_join_sneakle,_join_si,join_btn_pos[1,0],join_btn_pos[1,1],(0.22+(0.1*game_finished_fd2))*_scl*(1+(0.05*pulse_1*game_finished_fd2))*join_btn_scl[1],(0.22+(0.1*game_finished_fd2))*_scl*(1+(0.05*-pulse_1*game_finished_fd2))*join_btn_scl[1],0,c_white,(0.8*_join_alp)-(2*game_finished_fd2))

		if _glow_amt > 0 {
			gpu_set_blendmode(bm_add)
			draw_sprite_ext(spr_join_sneakle,2,join_btn_pos[1,0],join_btn_pos[1,1],(0.22+(0.1*_glow_amt))*_scl*(1.1+(0.03*-pulse_1*_glow_amt)),(0.22+(0.1*_glow_amt))*_scl*(1.1+(0.03*pulse_1*_glow_amt)),0,make_colour_hsv(30,250,255),0.2*pulse_1*_glow_amt)
			gpu_set_blendmode(bm_normal)
		}
		
		
		//2
		
		join_btn_on[2] = 0
		if game_finished_fd > 0.1 {
			join_btn_on[2] = 1
		}
		join_btn_pos[2,0] = (global.sw*1)+(-10*_scl)+((-37+(-15*game_finished_fd))*_scl)
		join_btn_pos[2,1] = gui_footer_mid_y+((0+(-12*game_finished_fd))*_scl)
		
		var _join_si = 0
		_glow_amt = 1
		_join_alp = 1
		
		if obj_ctrlp.profile_joined = "-0.1" {
			_join_alp *= 0.4
			_glow_amt *= 0.1
		}
	
		if game_finished_fd > 0 {
			_join_si = 1
			gpu_set_blendmode(bm_add)
			draw_sprite_ext(spr_circ_grad512,0,join_btn_pos[2,0],join_btn_pos[2,1],0.8*_scl*(0.5)*pulse_5*(1+(0.1*-pulse_1*game_finished_fd)),0.4*_scl*(0.5)*pulse_5*(1+(0.1*pulse_1*game_finished_fd)),0,_highlight_blue,_glow_amt*game_finished_fd*pulse_5)
			//draw_sprite_ext(spr_join_sneakle,1,(global.sw*0.0)+(20*_scl)+(47*_scl),_nav_mid_y+(0*_scl),0.3*_scl*(1)*pulse_5,0.3*_scl*(1)*pulse_5,0,c_white,1*game_finished_fd*pulse_5)
	
			draw_sprite_ext(spr_join_sneakle,2,join_btn_pos[2,0],join_btn_pos[2,1],(0.22+(0.1*game_finished_fd))*_scl*(1.1+(0.03*-pulse_1*game_finished_fd)),(0.22+(0.1*game_finished_fd))*_scl*(1.1+(0.03*pulse_1*game_finished_fd)),0,make_colour_hsv(25,200,255),0.5*_glow_amt*game_finished_fd)

	
			gpu_set_blendmode(bm_normal)
		}

		draw_sprite_ext(spr_join_sneakle,_join_si,join_btn_pos[2,0],join_btn_pos[2,1],(0.22+(0.1*game_finished_fd))*_scl*(1+(0.05*pulse_1*game_finished_fd)),(0.22+(0.1*game_finished_fd))*_scl*(1+(0.05*-pulse_1*game_finished_fd)),0,c_white,-0.5+(2*game_finished_fd*_join_alp))

		if game_finished_fd > 0 {
			gpu_set_blendmode(bm_add)
			draw_sprite_ext(spr_join_sneakle,2,join_btn_pos[2,0],join_btn_pos[2,1],(0.22+(0.1*game_finished_fd))*_scl*(1.1+(0.03*-pulse_1*game_finished_fd)),(0.22+(0.1*game_finished_fd))*_scl*(1.1+(0.03*pulse_1*game_finished_fd)),0,make_colour_hsv(30,250,255),0.2*_glow_amt*pulse_1*game_finished_fd)
			gpu_set_blendmode(bm_normal)
		}
	
	
		//
	
	
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 && global.game_timer > 10 {
			
			var _join_clicked = 0
			
			for (var i = 1; i <= 2; ++i) {
				if join_btn_on[i] >= 1 {
					if scr_mouse_over_button(
					join_btn_pos[i,0],
					join_btn_pos[i,1],
					(0.22+(0.1*game_finished_fd2))*_scl,0.085*_scl
					) {
						_join_clicked = 1
					}
				}
			}
			
			
			if _join_clicked = 1 {
				
				if real(obj_ctrlp.profile_joined) <= 0 {
					show_debug_message("JOIN CLICKED")
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
					with (obj_ctrlp) {
						
						profile_joined = "-0.1"
						
						api_join_subreddit(function(_status, _ok, _result) {
							try {
								show_debug_message("api_join_subreddit SUCCESS!")
								
								//now update profile_joined for user
								profile_joined = "1"
								api_save_profile({profile_joined},undefined)
								
							}
							catch (_ex) {
								profile_joined = "0"
								show_debug_message("api_join_subreddit FAILED!")
								show_debug_message(_ex)
								//alarm[1] = 120; //try again
							}
	
						});
						
						
					}
			
				}
			}
		}
	}

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
		
		
		//obj_ctrlp.postData_dailyID = -1
		
		var _daily_id = string(obj_ctrlp.postData_dailyID)
		var _daily_btn_si = 0
		//if _daily_id = "-1" {
		//	_daily_id = "-"
		//	_daily_btn_si = 3
		//}
		
		
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
		
		draw_sprite_ext(spr_btn_6,_daily_btn_si,(global.sw*0.5),0+(210*_scl)+(110*_scl*0)+(6*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_6,_daily_btn_si,(global.sw*0.5),0+(210*_scl)+(110*_scl*0),0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
		//draw_set_font(fnt_main)
		//draw_set_alpha(0.9*ctrl_fd)
		//if _daily_id != "-" {
		//	draw_set_color(c_white)
		//	draw_text_transformed(global.sw/2,0+(210*_scl)+(110*_scl*0)+(15*_scl),_daily_id,0.17*_scl,0.17*_scl,0)
		//}
		

		
		draw_set_color(c_white)
		
		//archive
		draw_sprite_ext(spr_btn_6,1,(global.sw*0.5),0+(210*_scl)+(80*_scl*1)+(6*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_6,1,(global.sw*0.5),0+(210*_scl)+(80*_scl*1),0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
		
		
		//create
		draw_sprite_ext(spr_btn_6,2,(global.sw*0.5),0+(210*_scl)+(80*_scl*2)+(6*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_6,2,(global.sw*0.5),0+(210*_scl)+(80*_scl*2),0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
		
		//sep line
		draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(210*_scl)+(80*_scl*2)+(70*_scl),0.65*_scl,0.004*_scl,0,_c_white,0.2*ctrl_fd) 
	
	
		draw_set_alpha(0.6*ctrl_fd)
		draw_set_font(fnt_main)
		draw_set_color(_c_white)
		draw_text_transformed(global.sw/2,(210*_scl)+(80*_scl*2)+(110*_scl),"U N L I M I T E D !",0.14*_tscl,0.14*_tscl,0)

		draw_set_alpha(0.9*ctrl_fd)
		draw_set_color(c_white)
		
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl)+(6*_scl)	,	0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl)+(6*_scl)	,		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-0*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl)+(6*_scl),		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl)+(6*_scl),		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl)+(6*_scl)	,		0.25*_scl,0.25*_scl,0,_c_gray,1*ctrl_fd) 
		
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),	0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(-0*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		draw_sprite_ext(spr_btn_7,0,(global.sw*0.5)+(160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),		0.25*_scl,0.25*_scl,0,c_white,1*ctrl_fd) 
		
	
		draw_text_transformed((global.sw*0.5)+(-160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),"3x3",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(-80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),	"4x4",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(-0*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),	"5x5",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(80*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),	"6x6",0.14*_tscl,0.14*_tscl,0)
		draw_text_transformed((global.sw*0.5)+(160*_scl),0+(210*_scl)+(80*_scl*2)+(180*_scl),	"7x7",0.14*_tscl,0.14*_tscl,0)

		
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
	
	draw_set_alpha(0.5)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,65*_scl,"drag to rearrange the letters",0.16*_tscl,0.16*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)

	var _confirm_blocked_by_banned = 0
	var _phase1_grid_sig = string(global.game_grid_size) + "|"
	for (var _i = 1; _i <= global.game_grid_size_sqr; ++_i) {
		var _sig_part = "_|"
		var _tile = global.tile_letter[_i]
		if instance_exists(_tile) && _tile.am_set >= 1 {
			var _targ = _tile.targ_id
			if instance_exists(_targ) && _targ != -1 {
				_sig_part = string(_targ.tile_id) + ":" + string_lower(_tile.my_letter_str) + "|"
			}
		}
		_phase1_grid_sig += _sig_part
	}

	if _phase1_grid_sig != phase1_banned_scan_signature {
		phase1_banned_scan_signature = _phase1_grid_sig

		if ready_for_phase2 >= 1 {
			phase1_grid_has_banned_words = scr_grid_has_banned_words()
			show_debug_message("GRID SIG: " + _phase1_grid_sig)
			show_debug_message("GRID HAS BANNED WORDS: " + string(phase1_grid_has_banned_words))
		} else {
			phase1_grid_has_banned_words = 0
		}
	}

	_confirm_blocked_by_banned = phase1_grid_has_banned_words
	
	
	
	
	if global.game_mode = 1 {
		
		draw_set_alpha(0.6)
	
		draw_set_font(fnt_main)
	

		draw_set_color(_c_white)
		draw_set_valign(fa_middle)
		
		var _btn_alps = 1+(dragging_fd*-0.6)
		var _btn_cols = merge_colour(global.background_col,_c_white,0.1+(global.light_mode*0.1))
		
		draw_set_color(_c_white)
		
		if dragging > 0 {
			_btn_cols = merge_colour(global.background_col,c_dkgray,0.4)
			draw_set_color(c_gray)
		}
		
		draw_set_alpha(0.7*_btn_alps)
		
		
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-180*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-180*_scl),global.sh-(140*_scl),"3x3",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-90*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-90*_scl),global.sh-(140*_scl),"4x4",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-0*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-0*_scl),global.sh-(140*_scl),"5x5",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(90*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(90*_scl),global.sh-(140*_scl),"6x6",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(180*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(180*_scl),global.sh-(140*_scl),"7x7",0.10*_tscl,0.10*_tscl,0)
	
	
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				
				var _which_sz_clicked = -1
				
				if 			scr_mouse_over_button((global.sw*0.5)+(-180*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl) {
					show_debug_message("3 CLICKED")
					_which_sz_clicked = 3
				} else if	scr_mouse_over_button((global.sw*0.5)+(-90*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl) {
					show_debug_message("4 CLICKED")
					_which_sz_clicked = 4
				} else if	scr_mouse_over_button((global.sw*0.5)+(-0*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl) {
					show_debug_message("5 CLICKED")
					_which_sz_clicked = 5
				} else if	scr_mouse_over_button((global.sw*0.5)+(90*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl) {
					show_debug_message("6 CLICKED")
					_which_sz_clicked = 6
				} else if	scr_mouse_over_button((global.sw*0.5)+(180*_scl),global.sh-(140*_scl),0.115*_tscl,0.07*_tscl) {
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
	
	
		
	
		
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(-148*_scl),global.sh-(198*_scl),0.24*_tscl,0.108*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(-148*_scl),global.sh-(198*_scl),"RANDOM\nNEW LETTERS",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(0*_scl),global.sh-(198*_scl),0.28*_tscl,0.108*_tscl,0,merge_color(_btn_cols,_highlight_blue,1),1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(0*_scl),global.sh-(198*_scl),"TYPE\nLETTERS",0.10*_tscl,0.10*_tscl,0)
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(148*_scl),global.sh-(198*_scl),0.24*_tscl,0.108*_tscl,0,_btn_cols,1*_btn_alps)
		draw_text_transformed((global.sw*0.5)+(148*_scl),global.sh-(198*_scl),"SHUFFLE\nGRID",0.10*_tscl,0.10*_tscl,0)
	
		
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
		
		
	
		draw_sprite_ext(spr_sqr512,0,(global.sw*0.5)+(0*_scl),global.sh-(254*_scl),0.815*_tscl*(1+(0.02*-obj_ctrl.pulse_2*dragging_fd)),0.06*_tscl*(1+(0.00*obj_ctrl.pulse_2*dragging_fd)),0,_swap_col,_swap_alp*0.5)
		
		draw_sprite_ext(spr_sqr512,1,(global.sw*0.5)+(0*_scl),global.sh-(254*_scl),0.815*_tscl*(1+(0.02*-obj_ctrl.pulse_2*dragging_fd)),0.06*_tscl*(1+(0.00*obj_ctrl.pulse_2*dragging_fd)),0,_swap_col,-0.05+_swap_alp)
		
		draw_text_transformed((global.sw*0.5)+(0*_scl),global.sh-(254*_scl),"HOVER TO ADJUST LETTER",(0.09+(-0.01*dragging_fd))*_tscl,0.09*_tscl,0)
	
		draw_set_alpha(0+(0.8*dragging_fd))
		draw_text_transformed((global.sw*0.5)+(0*_scl),global.sh-(254*_scl),"-1                                                  +1",0.15*_tscl*(1.1+((0.15+(0.01*-obj_ctrl.pulse_2))*dragging_fd)),0.15*_tscl,0)
	
	
		draw_set_color(_c_white)
		draw_set_alpha(0.7)
		
		
		if mouse_check_button(mb_left) && global.show_any_modal <= 0 {
			
			var _hovered_over_changer_rt = 5
			var _timey_mod = 40
			_timey_mod = floor(lerp(_timey_mod,12,(obj_ctrl.hovered_over_changer/_hovered_over_changer_rt)))
			
			if dragging >= 1 && dragging_fd >= 0.5 {
				obj_ctrl.hovered_over_changer_timey += 1
			} else {
				obj_ctrl.hovered_over_changer_timey = 0
				obj_ctrl.hovered_over_changer = 0
			}
			
			if dragging >= 1 && dragging_fd >= 0.5 && (obj_ctrl.hovered_over_changer_timey mod _timey_mod = 0) {
				if	scr_mouse_over_button((global.sw*0.5)+(0*_scl),global.sh-(254*_scl),0.815*_tscl,0.064*_tscl) {
					//show_debug_message("X HELD")
					//show_debug_message(_timey_mod)
					show_debug_message(obj_ctrl.hovered_over_changer)
					
					with (obj_tile_letter) {
						if am_dragging >= 1 && am_dragging_fd > 0.9 {
							
							obj_ctrl.hovered_over_changer += 1
							obj_ctrl.hovered_over_changer = clamp(obj_ctrl.hovered_over_changer,0,_hovered_over_changer_rt)
							obj_ctrl.hovered_over_changer_timey = 1
							
							am_dragging_flash = 2
							am_hoverchanged_flash = 1
							
							if (device_mouse_x_to_gui(0)*global.pr) <= (global.sw*0.5) {
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
							my_letter_str = string_upper(global.letter_data[my_letter_num,1])
						
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
				if				scr_mouse_over_button((global.sw*0.5)+(-148*_scl),global.sh-(198*_scl),0.24*_tscl,0.108*_tscl) {
					
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
					
			} else if	scr_mouse_over_button((global.sw*0.5)+(0*_scl),global.sh-(198*_scl),0.276*_tscl,0.108*_tscl) {
					show_debug_message("B CLICKED")
					
					show_debug_message("TYPE LETTERS")
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))

					var _event_struct = { //
					   screen_name: "LoadFromCreate",
					};
					GoogHit("screen_view",_event_struct)
					
					if 1=0 { //html5
					
						global.show_TypeLetters_input_prompt = 1
					
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
						
						
						global.show_TypeLetters_input_prompt = 1
						
						if global.do_basic_input = 1 {
							
							global.show_TypeLetters_input_prompt = 0
						
							async_msg_letters = get_string_async("Enter the letters you want to use.\n(Length needs to be a square number: 9 | 16 | 25 | 36 | 49)\n(Excess length with be rounded down to nearest square number.)", string(_current_board)); 
							//will set create_typed_letters in async dialog
						
						} else if global.is_reddit = 1 {
						
							//global.show_input_prompt = 1
							//if 1=1 {
							
							//    var data = {
							//        "scr": "addClassElemID",
							//        "args": ["CreateTypeLetters", "active"]
							//    };

							//    window_post_message(json_stringify(data));
						
							//}
							
							if global.is_mobile >= 1 {
								addClassElemID("modalCreateTypeLetters","active")
							}
							setElementProperty("CreateTypeLettersInput","value",string(_current_board))
							
							keyboard_string = string(_current_board)
							//keyboard_virtual_show(kbv_type_ascii,kbv_returnkey_continue,kbv_autocapitalize_characters,false)
						
							
						} else {
							
							keyboard_string = string(_current_board)
							//async_msg_letters = get_string_async("Enter the letters you want to use.\n(Length needs to be a square number: 9 | 16 | 25 | 36 | 49)\n(Excess length with be rounded down to nearest square number.)", string(_current_board)); 
							//will set create_typed_letters in async dialog
							
						}
					
					}
					
				}
			}
		}
	
	
	}
	
	if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
		if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			if global.game_mode = 1 && scr_mouse_over_button((global.sw*0.5)+(148*_scl),global.sh-(198*_scl),0.24*_tscl,0.108*_tscl) {
				show_debug_message("SHUFFLE CLICKED")
				
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
				var _all_spaces = []
				with (obj_tile_space) {
					array_push(_all_spaces, id)
				}
				_all_spaces = array_shuffle(_all_spaces)
				
				var _si = 0
				with (obj_tile_letter) {
					targ_id = _all_spaces[_si]
					x_targ = targ_id.x
					y_targ = targ_id.y
					tile_id = targ_id.tile_id
					prev_targ_id = targ_id
					am_set = 1
					am_set_flash = 1
					born_fd = 0.3
					_si += 1
				}
				
				global.current_copy_code = ""
				global.current_copy_link = ""
				scr_update_copy_code()
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
		
		var _confirm_btn_col_outer = merge_colour(_highlight_blue,c_white,0.4)
		var _confirm_btn_col_inner = _highlight_blue
		var _confirm_btn_title = "CONFIRM GRID"
		var _confirm_btn_title_scl = 0.2
		var _confirm_btn_subtitle = "proceed to set SECRET"
		
		if _confirm_blocked_by_banned >= 1 {
			_confirm_btn_col_outer = merge_colour(make_colour_hsv(2,250,95),c_white,0.15)
			_confirm_btn_col_inner = make_colour_hsv(2,90,35)
			_confirm_btn_title = "BANNED WORD FOUND IN GRID :("
			_confirm_btn_title_scl = 0.16
			_confirm_btn_subtitle = "uh oh, can't allow that!"
		}
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl,0,_confirm_btn_col_outer,1)
		draw_sprite_ext(spr_sqr512,0,global.sw/2,global.sh-(65*_scl),0.819*_scl,0.17*_scl,0,_confirm_btn_col_inner,1)
		
		draw_set_valign(fa_middle)
		draw_set_alpha(0.7+(-0.6*dragging_fd))
		draw_text_transformed(global.sw/2,global.sh-(75*_scl),_confirm_btn_title,_confirm_btn_title_scl*_scl,_confirm_btn_title_scl*_scl,0)
		draw_text_transformed(global.sw/2,global.sh-(50*_scl),_confirm_btn_subtitle,0.12*_scl,0.12*_scl,0)
		
		draw_set_alpha(0.7)
		
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if _confirm_blocked_by_banned <= 0 && scr_mouse_over_button(global.sw/2,global.sh-(65*_scl),0.83*_scl,0.18*_scl) {
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
					selected_word_not_allowed = 0
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
	
	draw_set_alpha(0.5)
	draw_set_font(fnt_main_r)
	draw_text_transformed(global.sw/2,75*_scl,"swipe to set your SECRET WORD",0.15*_tscl,0.15*_tscl,0)
	draw_set_font(fnt_main)
	
	draw_set_alpha(0.7)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5+(-120*_scl),global.sh-28*_scl,0.38*_tscl,0.08*_tscl,0,_highlight_blue,1)
	draw_text_transformed(global.sw*0.5+(-120*_scl),global.sh-28*_scl,"<  BACK TO REARRANGE",0.11*_tscl,0.11*_tscl,0)
	
	
	draw_set_alpha(0.7)
	
	
	
	if nonstandard_allowed = 0 {
	
		draw_sprite_ext(spr_sqr512,0,global.sw*0.5+(120*_scl),global.sh-28*_scl,0.38*_tscl,0.08*_tscl,0,_c_white,0.1)
		draw_text_transformed(global.sw*0.5+(120*_scl),global.sh-28*_scl,"allow any secret: OFF\n(recommended)",0.09*_tscl,0.09*_tscl,0)
	
	} else {
	
		draw_sprite_ext(spr_sqr512,0,global.sw*0.5+(120*_scl),global.sh-28*_scl,0.38*_tscl,0.08*_tscl,0,make_colour_hsv(10,230,200),1)
		draw_text_transformed(global.sw*0.5+(120*_scl),global.sh-28*_scl,"allow any secret: ON\n(NOT recommended!)",0.09*_tscl,0.09*_tscl,0)
	
	}
	
	if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
		if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
			if		scr_mouse_over_button(global.sw*0.5+(-120*_scl),global.sh-(28*_scl),0.38*_scl,0.18*_scl) {
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
			
			if		scr_mouse_over_button(global.sw*0.5+(120*_scl),global.sh-(28*_scl),0.38*_scl,0.18*_scl) {
				
				show_debug_message("F CLICKED")
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))

				nonstandard_allowed = !nonstandard_allowed
				
				//reset stuff
				selecting = 0
				selected_word_latest_tile = -1
				selected_word_latest_tile_id = noone
	
				selected_word_length = 0
				selected_word_str = ""	
				with (obj_tile_letter) {
					am_part_of_secret_word = 0	
				}
				
				with (obj_ctrl) {
					scr_validate_word()	
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
		
		var _confirm_word_str = "CONFIRM SECRET WORD?"
		if global.game_mode = 2 {
			_confirm_word_str = "SUBMIT"
		}
		
		
		
		var _confirm_warning = 0
		var _confirm_warning_str = ""
		
		
		if ready_for_phase3 >= 1 && nonstandard_allowed = 0 {
			
			
			_confirm_warning_str = ""
			
			if selected_word_length <= 4 {
				_confirm_warning = 1
				_confirm_warning_str += "SECRET should be longer! (5+)"
			}
			
			if selected_word_is_valid < 2 {
				if _confirm_warning = 1 {
					_confirm_warning_str += "\n+ "	
				}
				_confirm_warning = 1
				_confirm_warning_str += "SECRET is not a standard dictionary word!"
			}
			
			if selected_word_length >= 4 {
				if string_ends_with(string(selected_word_str),"S") {
					if _confirm_warning = 1 {
						_confirm_warning_str += "\n+ "	
					}
					_confirm_warning = 1
					_confirm_warning_str += "SECRET ends in 'S', avoid plurals!"	
				}
			}
			
			if _confirm_warning = 1 {
				_confirm_word_str = "*** CONFIRM SECRET WORD? ***\nwith issues below"	
			}
			
			
			
			
		}
		
		
		if _confirm_warning = 1 {
			_confirm_word_col = make_colour_hsv(10,230,200)
		}
		
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,(_panel_mid_y)+(80*_scl),0.65*_tscl*(1+(0.03*pulse_1*_confirm_warning)),0.13*_tscl,0,merge_colour(_confirm_word_col,c_white,0.4),draw_get_alpha())
		
		draw_sprite_ext(spr_sqr512,0,global.sw/2,(_panel_mid_y)+(80*_scl),0.641*_tscl*(1+(0.03*pulse_1*_confirm_warning)),0.124*_tscl,0,_confirm_word_col,draw_get_alpha())
		
		
		
		
		
		
		if _confirm_warning = 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(80*_scl)+(-4*_confirm_warning*_scl),_confirm_word_str,0.12*_tscl,0.12*_tscl,0)
		} else {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(80*_scl),_confirm_word_str,0.15*_tscl,0.15*_tscl,0)
		}
		
		if _confirm_warning_str != "" {
			draw_set_valign(fa_top)
			
			draw_sprite_ext(spr_sqr512,0,global.sw/2,(_panel_mid_y)+(92*_scl)+(21*_confirm_warning*_scl)+(string_height(_confirm_warning_str)*0.11*_tscl*0.5),0.73*_tscl*(1+(0.03*-pulse_1)),0.005*((50+string_height(_confirm_warning_str))*0.11*_tscl*0.5),0,make_colour_hsv(2,230,100),1)
			
			draw_set_colour(make_colour_hsv(35,100,255))
		
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(92*_scl)+(21*_confirm_warning*_scl),_confirm_warning_str,0.11*_tscl,0.11*_tscl,0)
		}
		
		draw_set_valign(fa_middle)
		
		draw_set_alpha(0.3)
		draw_set_colour(_c_white)
		
		
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if !collision_point(mouse_x,mouse_y,obj_tile_letter,true,true) {
				if		scr_mouse_over_button(global.sw/2,(_panel_mid_y)+(80*_scl),0.65*_tscl,0.13*_tscl) {
					show_debug_message("G CLICKED")	
					if global.game_mode = 1 && selected_word_length >= 2 && (selected_word_is_valid >= 1 || real(obj_ctrlp.postData_nonStandard) >= 1 || nonstandard_allowed = 1) {
						//proceed, lock in word
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
						secret_word_length = selected_word_length
						secret_word_str = selected_word_str
						secret_word_array = selected_word_array
						secret_word_array_id = selected_word_array_id
						guesses_count = 0
				
						//selected_word_length = 0
						//selected_word_str = ""
						//selected_word_array = 0
				
						//with (obj_tile_letter) {
						//	am_exed = 0
						//	am_clued = 0	
						//}

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
						
						
						//global.show_submitting_post = 1
						
						create_title = ""
						
						//obj_ctrlp.username = "Acey"
						//obj_ctrlp.created_total = "2"
						if obj_ctrlp.username != "" {
							create_title = string(obj_ctrlp.username)
							create_title += "'s "
							
							if obj_ctrlp.created_total != "" {
								create_title += string(ordinal_string(real(obj_ctrlp.created_total)+1))+" "
							}
							
							create_title += "Custom Sneakle"
						} else {
							create_title = "My Custom Sneakle"
						}

						
						global.show_PostTitle_input_prompt = 1
						
						if global.do_basic_input = 1 {
							
							global.show_PostTitle_input_prompt = 0
							global.show_submitting_post = 1
						
							async_msg_title = get_string_async("Enter a title for your puzzle and submit. \n(*This will create a post as "+string(obj_ctrlp.username)+")", string(create_title)); 
							//will set create_typed_letters in async dialog
							
						
						} else if global.is_reddit = 1 {
							
							global.show_PostTitle_input_prompt = 1
						
							//global.show_input_prompt = 1
							//if 1=1 {
							
							//    var data = {
							//        "scr": "addClassElemID",
							//        "args": ["CreateTypeLetters", "active"]
							//    };

							//    window_post_message(json_stringify(data));
						
							//}
							
							if global.is_mobile >= 1 {
								addClassElemID("modalCreatePostTitle","active")
							}
							setElementProperty("CreatePostTitleInput","value",string(create_title))
							
							keyboard_string = string(create_title)
							//keyboard_virtual_show(kbv_type_ascii,kbv_returnkey_continue,kbv_autocapitalize_characters,false)
						
							
						} else {
							
							global.show_PostTitle_input_prompt = 1
							
							keyboard_string = string(create_title)
							//async_msg_letters = get_string_async("Enter the letters you want to use.\n(Length needs to be a square number: 9 | 16 | 25 | 36 | 49)\n(Excess length with be rounded down to nearest square number.)", string(_current_board)); 
							//will set create_typed_letters in async dialog
							
						}
				
						
						
						
						
				
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
	draw_text_transformed(global.sw/2,(_panel_mid_y)+(-68*_scl),"your SECRET WORD is",0.12*_tscl,0.12*_tscl,0)
	draw_set_font(fnt_main)

	
	var _letters_str = ""
	for (var l = 0; l < selected_word_length; ++l) {
		_letters_str += global.letters_grid[selected_word_array[l]]
	}
	
	draw_set_alpha(0.3)
	
	if selected_word_is_valid >= 1 {
		draw_set_alpha(0.7)
	}
	
	draw_set_font(fnt_main)
	var _max_width = 350//290
	var _letters_str_w = string_width(string(_letters_str)+"?")*_scl
			  
	var _letters_scl = min(0.4,(_max_width*_scl)/(_letters_str_w+0.1))
	//_letters_str_w *= _letters_scl
	
	//draw_text_transformed(global.sw/2,(global.sh*1)+(-200*_pos_scl),string(_letters_str),0.3*_tscl,0.3*_tscl,0)
	draw_text_transformed(global.sw/2,(_panel_mid_y)+(-20*_scl),string(_letters_str),_letters_scl*_tscl,_letters_scl*_tscl,0)
	
	draw_set_alpha(0.3)
	draw_set_font(fnt_main_r)
	var _nonstandard_guessing_allowed = (nonstandard_allowed >= 1) || (real(obj_ctrlp.postData_nonStandard) >= 1)
	if selected_word_length > 0 {
		if selected_word_length < ((_nonstandard_guessing_allowed) ? 2 : 5) {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(25*_scl),"too short",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_not_allowed >= 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(25*_scl),"word not allowed",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_not_in_dictionary >= 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(25*_scl),"not a valid word",0.15*_tscl,0.15*_tscl,0)
		} else if selected_word_already_guessed >= 1 {
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(25*_scl),"already guessed",0.15*_tscl,0.15*_tscl,0)
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
	
	
	if 1=1 {
	if global.game_phase != 4 {
		draw_set_font(fnt_main_r)
		draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.31),"can you guess the SECRET WORD?",0.15*_tscl,0.15*_tscl,0)
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
		
		if obj_ctrlp.already_finished >= 2 {
			draw_set_valign(fa_middle)
			draw_set_alpha(0.4)
			var _already_played_str = "ALREADY PLAYED!"
			if obj_ctrlp.already_finished = 3 {
				_already_played_str = "THIS IS YOUR PUZZLE!"
			}
			draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*-0.295),_already_played_str,0.09*_tscl,0.09*_tscl,0)
		}
		
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
		_letters_str_w = string_width(string(_letters_str)+"?")*_scl
			  
		_letters_scl = min(0.4,(_max_width*_scl)/(_letters_str_w+0.1))
		
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
				var _len_x = (global.sw/2)+(_letters_str_w*0.5)+(_length_str_w*0.0)
				var _len_y = _panel_mid_y+(_panel_ht*-0.01)+(_panel_ht*game_finished_fd2*-0.12)
				draw_text_transformed(_len_x,_len_y,string(_length_str),_letters_scl*0.45*_tscl,_letters_scl*0.45*_tscl,0)

				if hint_len_flash_fd > 0.001 {
					gpu_set_blendmode(bm_add)
					draw_sprite_ext(spr_circ_grad128,0,_len_x,_len_y,0.6*_scl*(1+(0.8*(1-hint_len_flash_fd))),0.4*_scl*(1+(0.8*(1-hint_len_flash_fd))),0,make_colour_hsv(36,220,255),clamp(2*hint_len_flash_fd,0,0.4))
					gpu_set_blendmode(bm_normal)
				}
				
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
	
	
	if 1=1 {
	
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
			if selected_word_is_valid = 3 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"non-standard guesses allowed",0.15*_tscl,0.15*_tscl,0)
			} else if selected_word_length >= 2 && selected_word_length < (((nonstandard_allowed >= 1) || (real(obj_ctrlp.postData_nonStandard) >= 1)) ? 2 : 4) {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"too short",0.15*_tscl,0.15*_tscl,0)
			} else if selected_word_too_long >= 1 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"too long",0.15*_tscl,0.15*_tscl,0)
			} else if selected_word_not_allowed >= 1 {
				draw_text_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.16),"word not allowed",0.15*_tscl,0.15*_tscl,0)
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
			
			//_score_total_str = "111"
			draw_text_transformed((global.sw/2)+(-37*_scl)+(54*_scl),(_panel_mid_y)+(_panel_ht*0.27)+(_panel_ht*-0.07*game_finished_fd2),string(_score_total_str),0.24*_tscl,0.24*_tscl,0)
			draw_text_transformed((global.sw/2)+(-8*_scl)+(54*_scl),(_panel_mid_y)+(_panel_ht*0.27)+(_panel_ht*-0.07*game_finished_fd2)+(-1*_scl),"pts",0.12*_tscl,0.12*_tscl,0)
	
	
			var _lb_btn_alp = 3
			var _lb_btn_col = c_white
			// if obj_ctrlp.lb_your_rank = -1 && obj_ctrlp.already_finished != 3 {
			// 	_lb_btn_alp = 0.2
			// 	_lb_btn_col = c_ltgray
			// }
			//lb
			draw_sprite_ext(spr_btn_2,2,global.sw/2+(88*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2),(1)*(_scl*0.25),(1)*(_scl*0.25),0,_lb_btn_col,_lb_btn_alp*game_finished_fd2)
		
		
			var _cm_btn_alp = 3
			var _cm_btn_col = c_white
			//obj_ctrlp.level_commented = 0
			if obj_ctrlp.level_commented >= 1 || obj_ctrlp.already_finished = 3 {
				_cm_btn_alp = 0.2
				_cm_btn_col = c_ltgray
			}
			
			//if obj_ctrlp.lb_your_rank = -1 {
			//	_cm_btn_alp = 0.2
			//	_cm_btn_col = c_ltgray
			//}
		
			//comment
			draw_sprite_ext(spr_btn_2,3,global.sw/2+(-88*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2),(1)*(_scl*0.25),(1)*(_scl*0.25),0,_cm_btn_col,_cm_btn_alp*game_finished_fd2)
		
			if obj_ctrlp.level_commented >= 1 {
				draw_sprite_ext(spr_checkmark,3,global.sw/2+(-88*_scl)+(-59*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2),(1)*(_scl*0.18),(1)*(_scl*0.18),0,_cm_btn_col,0.7*game_finished_fd2)
			}
		
		
			if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
				if scr_mouse_over_button(global.sw/2+(88*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2),
				0.31*_scl,0.0983*_scl) {
					show_debug_message("LB CLICKED")
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				
					//global.show_lb = 1
					var _lb_level_name = string(obj_ctrlp.postData_levelName);
					var _lb_author = "";
					if obj_ctrlp.puzzle_is_community = 1 {
						_lb_author = string(obj_ctrlp.postData_levelCreator);
					}

					showGameLeaderboard(obj_ctrlp.postId, _lb_level_name, _lb_author);

				}
				
				if scr_mouse_over_button(global.sw/2+(-88*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2),
				0.31*_scl,0.0983*_scl) {
					if obj_ctrlp.level_commented <= 0 && obj_ctrlp.already_finished < 3 {
						
						show_debug_message("COMMENT CLICKED")
					
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						with (obj_ctrlp) {
							level_commented = 1
							api_save_state(postId,{level_commented},undefined)
						
							api_comment_score(postId,score_combined,undefined)
						
						
						}
					
					}
				
					//global.show_lb = 1
				}
			}
		
		}
	
	
		if global.game_phase = 4 && obj_ctrlp.puzzle_is_unlimited != 1 {
	
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_set_font(fnt_main_r)
			draw_set_color(c_white)
			draw_set_alpha(0.7*game_finished_fd2)
	
			var _rank_str = ""
			var _rank_str_scl = 1
		
			if obj_ctrlp.already_finished = 3 {
				_rank_str = "can't rank on your own puzzle :)"
				_rank_str_scl = 0.75
			} else if obj_ctrlp.lb_your_rank = -1 {
				draw_set_alpha(0.15*game_finished_fd2)
				_rank_str = "loading rank..."
			} else {
				_rank_str = $"rank {obj_ctrlp.lb_your_rank} of {obj_ctrlp.lb_total_players} - top {obj_ctrlp.lb_your_percentile}%!"
			}

			draw_text_ext_transformed(global.sw/2+(88*_scl)+(15*_scl),(_panel_mid_y)+(_panel_ht*0.46)+(_panel_ht*-0.07*game_finished_fd2)+(7*_scl),_rank_str,160,3600,0.08*_tscl*_rank_str_scl,0.08*_tscl*_rank_str_scl,0)
		
		
		
			draw_set_halign(fa_center)
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
		if !is_undefined(guesses_list[i]) && is_string(guesses_list[i]) {
			if guesses_list[i] != "" {	
				_guess_list_str += guesses_list[i]
				if i < array_length(guesses_list)-1 {
					_guess_list_str += ", "
				}
			}
		}
	}
	
	//_guess_list_str += _guess_list_str
	
	if global.game_phase = 4 {
		//don't show guess list on end screen
	} else {
		draw_text_ext_transformed(global.sw/2,(_panel_mid_y)+(_panel_ht*0.4),string(_guess_list_str),160,3600,0.1*_tscl,0.1*_tscl,0)
	}
	
	
	if global.game_phase = 4 { //stats
		
		var _which_stats = STATS_UNLIMITED
		if obj_ctrlp.puzzle_is_daily = 1 {
			_which_stats = STATS_DAILY
		} else if obj_ctrlp.puzzle_is_community = 1 {
			_which_stats = STATS_COMMUNITY
		}
		
		var _stat_h = 50
		var _stat_y = 0.7+((1-game_finished_fd)*-0.2)
		
		scr_draw_stats(_which_stats,_panel_mid_y+((1-game_finished_fd)*-0.2*_panel_ht),_scl,game_finished_fd)
	
		
	
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
			
				//draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,35+100*_yest_btn_enabled),3*game_finished_fd)
				//draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
			
				//draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				//draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
				var _sin_middle_offset = 1.5
				var _sin_last_offset = 3
			
				draw_sprite_ext(spr_btn,13,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,65+70*_yest_btn_enabled),3*game_finished_fd)
				draw_sprite_ext(spr_btn,13,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*_yest_btn_enabled*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
				if _yest_btn_enabled = 0 {
					draw_sprite_ext(spr_btn,18,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*_yest_btn_enabled*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,80),0.4*game_finished_fd)
				}
			
				draw_sprite_ext(spr_btn,19,global.sw/2+(-0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,19,global.sw/2+(-0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-((obj_ctrl.timey*0.07)+(_sin_middle_offset))))),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
				draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-((obj_ctrl.timey*0.07)+(_sin_last_offset))))),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
				//draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				//draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
			
				if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
					if scr_mouse_over_button(global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 1 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						////play previous
						if obj_ctrlp.daily_prev_postId != "-9999" {
					
							scr_reddit_reset_post()

							//load prev id
							scr_reddit_load_post(obj_ctrlp.daily_prev_postId)
				
						} else {
							show_debug_message("no obj_ctrlp.daily_prev_postId")
						}
					
					}
				
					if scr_mouse_over_button(global.sw/2+(0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 2 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
						
						var _event_struct = { //
						   screen_name: "Archives",
						};
						GoogHit("screen_view",_event_struct)
						
						if global.is_reddit = 1 {
							global.show_archives = 0
							showGameArchive("true")
						} else if global.is_reddit = 0 {
							global.show_archives = 1
							global.browser_tag = "daily"
							global.browser_cursor = 0
							global.browser_puzzles = []
							global.browser_hasMore = true
							global.browser_loading = false
						}
					}
					
					if scr_mouse_over_button(global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 3 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						if 1 = 1 { //go to create mode
							obj_ctrlp.already_finished = 0 //reset this so that puzzles don't auto complete moving forward	
							obj_ctrlp.daily_prev_postId = "-9999"
							obj_ctrlp.daily_next_postId = "-9999"
							
							scr_board_reset_defs()
						
							scr_reddit_reset_post()
							//room_restart()
							
							global.game_grid_size = 4
							global.game_grid_size_sqr = sqr(global.game_grid_size)
							global.am_creating = 1
							global.am_creating_fd2 = 1
							global.am_creating_fd = 1
							
							game_finished_fd = 0
							
							var _event_struct = { //
							   screen_name: "CreateFromDailyEnd"+string(global.game_grid_size),
							};
							GoogHit("screen_view",_event_struct)
							
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
							
							
						}
					}
				}
			
			} else { //not daily
				
				var _yest_btn_enabled = 0
				if obj_ctrlp.daily_today_postId != "-9999" {
					_yest_btn_enabled = 1	
				}
			
				//draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,35+100*_yest_btn_enabled),3*game_finished_fd)
				//draw_sprite_ext(spr_btn,0,global.sw/2+(-110*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
			
				//draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				//draw_sprite_ext(spr_btn,4,global.sw/2+(110*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
				var _sin_middle_offset = 1.5
				var _sin_last_offset = 3
			
				draw_sprite_ext(spr_btn,16,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,65+70*_yest_btn_enabled),3*game_finished_fd)
				draw_sprite_ext(spr_btn,16,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*_yest_btn_enabled*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,55+200*_yest_btn_enabled),3*game_finished_fd)
				if _yest_btn_enabled = 0 {
					draw_sprite_ext(spr_btn,18,global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*_yest_btn_enabled*(sin(-obj_ctrl.timey*0.07))),(1+(0+(0.015*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(-0.025*_yest_btn_enabled*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,make_colour_hsv(0,0,80),0.4*game_finished_fd)
				}
				
				var _unlimited_si = 19
				
				draw_sprite_ext(spr_btn,_unlimited_si,global.sw/2+(-0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,_unlimited_si,global.sw/2+(-0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-((obj_ctrl.timey*0.07)+(_sin_middle_offset))))),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
				draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(-((obj_ctrl.timey*0.07)+(_sin_last_offset))))),(1+(0+(0.015*(sin(((obj_ctrl.timey*0.07)+(_sin_last_offset)))))))*(_scl*0.25),(1+(0+(-0.025*(sin(((obj_ctrl.timey*0.07)+(_sin_middle_offset)))))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
				//draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,_c_gray,3*game_finished_fd)
				//draw_sprite_ext(spr_btn,15,global.sw/2+(145*_scl)+((1-game_finished_fd)*1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl)+(5*_scl*(sin(obj_ctrl.timey*0.07))),(1+(0+(-0.015*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),(1+(0+(0.025*(sin(obj_ctrl.timey*0.07)))))*(_scl*0.25),0,c_white,3*game_finished_fd)
			
			
			
				if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
					if scr_mouse_over_button(global.sw/2+(-145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 1 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						////play previous
						if obj_ctrlp.daily_today_postId != "-9999" {
					
							scr_reddit_reset_post()

							//load prev id
							scr_reddit_load_post(obj_ctrlp.daily_today_postId)
				
						} else {
							show_debug_message("no obj_ctrlp.daily_today_postId")
						}
					
					}
				
					if scr_mouse_over_button(global.sw/2+(0*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 2 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
						
						var _event_struct = { //
						   screen_name: "Archives",
						};
						GoogHit("screen_view",_event_struct)
						
						if global.is_reddit = 1 {
							global.show_archives = 0
							showGameArchive("true")
						} else if global.is_reddit = 0 {
							global.show_archives = 1
							global.browser_tag = "daily"
							global.browser_cursor = 0
							global.browser_puzzles = []
							global.browser_hasMore = true
							global.browser_loading = false
						}
					}
					
					if scr_mouse_over_button(global.sw/2+(145*_scl)+((1-game_finished_fd)*-1000*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((_stat_h+50)*_scl)+(-5*_scl),
					0.26*_scl,0.12*_scl) {
						show_debug_message("BTN 3 CLICKED")
						
						audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
					
						if 1 = 1 { //go to create mode
							obj_ctrlp.already_finished = 0 //reset this so that puzzles don't auto complete moving forward	
							obj_ctrlp.daily_prev_postId = "-9999"
							obj_ctrlp.daily_next_postId = "-9999"
							
							scr_board_reset_defs()
							scr_reddit_reset_post()
							//room_restart()
							
							global.game_grid_size = 4
							global.game_grid_size_sqr = sqr(global.game_grid_size)
							global.am_creating = 1
							global.am_creating_fd2 = 1
							global.am_creating_fd = 1
							
							game_finished_fd = 0
							
							var _event_struct = { //
							   screen_name: "CreateFromDailyEnd"+string(global.game_grid_size),
							};
							GoogHit("screen_view",_event_struct)
							
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
							
							
						}
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
	
	//draw_sprite_ext(spr_btn_5,3,(global.sw*0)+((20+5)*_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	var _nav_btn_edge_offset = (20+5)
	var _nav_btn_step = (34+5)
	var _nav_btn_x_howto = (global.sw*1)+(_nav_btn_edge_offset*-_scl)
	var _nav_btn_x_options = (global.sw*1)+((_nav_btn_edge_offset+_nav_btn_step)*-_scl)
	var _nav_btn_x_archive = (global.sw*1)+((_nav_btn_edge_offset+(_nav_btn_step*2))*-_scl)
	
	// left to right: archive (3), options (0), how to (1)
	draw_sprite_ext(spr_btn_5_narrow,3,_nav_btn_x_archive,_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	draw_sprite_ext(spr_btn_5_narrow,0,_nav_btn_x_options,_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	draw_sprite_ext(spr_btn_5_narrow,1,_nav_btn_x_howto,_nav_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)
	
	
	
	if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
		if scr_mouse_over_button(_nav_btn_x_archive,_nav_mid_y,
		0.073*_scl,0.0983*_scl) {
			show_debug_message("ARCHIVE CLICKED")
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))

			var _event_struct = { //
			   screen_name: "Archives",
			};
			GoogHit("screen_view",_event_struct)

			if global.is_reddit = 1 {
				global.show_archives = 0
				showGameArchive("true")
			} else if global.is_reddit = 0 {
				global.show_archives = 1
				global.browser_tag = "daily"
				global.browser_cursor = 0
				global.browser_puzzles = []
				global.browser_hasMore = true
				global.browser_loading = false
			}
		}
			
		if scr_mouse_over_button(_nav_btn_x_howto,_nav_mid_y,
		0.073*_scl,0.0983*_scl) {
			show_debug_message("HELP CLICKED")
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.show_howto = 1
		}
			
		if scr_mouse_over_button(_nav_btn_x_options,_nav_mid_y,
		0.073*_scl,0.0983*_scl) {
			show_debug_message("options CLICKED")
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			
			
			
			//addClassElemID("modalCreateTypeLetters","active")
			//setElementProperty("CreateTypeLettersInput","value",string(_current_board))
			
			global.show_options = 1
			obj_ctrlp.clear_stats_confirm = 0 //reset
		}
			
	}
	
}


if global.am_creating = 1 {
	if global.game_phase >= 1 && global.game_phase <= 2 {
		draw_set_alpha(0.6)
	
		draw_set_font(fnt_main_r)
		draw_set_alpha(0.7)
		draw_set_valign(fa_top)
	
		var _level_name_y_offset = 0
		_level_name = "C R E A T E   M O D E"
	
		draw_set_color(make_colour_hsv(35,200,255))
		if global.light_mode = 1 {
			draw_set_color(make_colour_hsv(35,240,155))
		}
		draw_set_alpha(0.7)
		draw_set_font(fnt_main)
		if _level_name != "" {
			draw_text_ext_transformed(global.sw*0.5,_nav_mid_y+((-8+_level_name_y_offset)*_scl),_level_name,150,2000,0.1*_tscl,0.1*_tscl,0)
		}
	
		draw_set_color(_c_white)
		draw_set_valign(fa_middle)	
	}
}

	
if global.game_phase >= 3 {
	
	draw_set_alpha(0.6)
	var _sscl = 0.12
	
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.7)
	draw_set_valign(fa_top)
	
	
	//obj_ctrlp.postData_levelName = "Custom Puzzle Custom Puzzle Custom Puzzle Custom Puzzle"//\naaa"// Custom Puzzle Custom Puzzle"
	var _level_name = obj_ctrlp.postData_levelName
	//_level_name = "Daily Sneakle #32"
	//obj_ctrlp.postData_levelTag = "daily"
	
	//obj_ctrlp.postData_levelDate_formatted = "Mon 2/12/2026"
	
	var _level_name_y_offset = 0
	var _has_levelDate_formatted = 0

	if 1=0 { //debug community
		_level_name = "MaxDoor's First Custom Puzzle First Custom Puzzle First Custom Puzzle"
		obj_ctrlp.puzzle_is_daily = 0
		obj_ctrlp.puzzle_is_community = 1
		obj_ctrlp.postData_levelCreator = "FermenterGames"
		obj_ctrlp.postData_nonStandard = "1"
	}

	var _has_level_creator = 0
	
	
	
	if obj_ctrlp.puzzle_is_daily = 1 {
		
		draw_set_alpha(0.5)
		
		var _levelDate_formatted = string(obj_ctrlp.postData_levelDate_formatted)
		if string_length(string(_levelDate_formatted)) > 2 {
			_level_name_y_offset = -8
			_has_levelDate_formatted = 1
		}
		
		_level_name = string_digits(_level_name)
		_level_name = "DAILY #"+_level_name
		
		
		
		if _has_levelDate_formatted {
			draw_text_transformed(global.sw*0.5,_nav_mid_y+((-8-_level_name_y_offset+(3))*_scl),_levelDate_formatted,0.08*_tscl,0.08*_tscl,0)	
		}
		
	} else if obj_ctrlp.puzzle_is_community = 1 || obj_ctrlp.puzzle_is_special = 1 {
		//
		
		draw_set_alpha(0.5)
		
		var _level_creator = "by u/"+string(obj_ctrlp.postData_levelCreator)
		if string_length(string(_level_creator)) > 2 {
			_level_name_y_offset = -8
			_has_level_creator = 1
		}

		var _level_creator_y_offset = 0
		draw_set_font(fnt_main)
		_level_creator_y_offset = clamp(-18+string_height_ext(_level_name,150,2000)*0.1,0,999)
		draw_set_font(fnt_main_r)
		
		if _has_level_creator = 1 {
			draw_text_transformed(global.sw*0.5,_nav_mid_y+((-8-_level_name_y_offset+_level_creator_y_offset+(3))*_scl),_level_creator,0.08*_tscl,0.08*_tscl,0)	
		}
		
		

		
	} else if obj_ctrlp.puzzle_is_unlimited = 1 {
		_level_name = "UNLIMITED "+string(global.game_grid_size)+"x"+string(global.game_grid_size)
	}
	
	draw_set_alpha(0.7)
	draw_set_font(fnt_main)
	if _level_name != "" {
		draw_text_ext_transformed(global.sw*0.5,_nav_mid_y+((-8+_level_name_y_offset)*_scl),_level_name,150,2000,0.1*_tscl,0.1*_tscl,0)
	}
	
	
	draw_set_valign(fa_middle)
	
	//prev next btns
	
	if obj_ctrlp.puzzle_is_daily = 1 {
	
		var _level_name_w = string_width(_level_name)*0.1
		var _prev_btn_enabled = 0
		var _next_btn_enabled = 0
		var _prev_btn_si = 0
		var _next_btn_si = 0
	
		if global.show_any_modal <= 0 {
			if obj_ctrlp.daily_prev_postId != "-9999" {
				_prev_btn_enabled = 1	
				if global.game_phase >= 4 && game_finished_fd > 0.98 {
					_prev_btn_si = 1
				}
			}
			if obj_ctrlp.daily_next_postId != "-9999" {
				_next_btn_enabled = 1
				if global.game_phase >= 4 && game_finished_fd > 0.98 {
					_next_btn_si = 1
				}
			}
		}
	
		draw_sprite_ext(spr_btn_4,_prev_btn_si,(global.sw*0.5)+(_level_name_w*0.5*-_scl)+(40*-_scl),_nav_mid_y,-0.25*_scl,0.25*_scl,0,make_colour_hsv(0,0,155+100*_prev_btn_enabled),0.4+(0.5*_prev_btn_enabled))

		draw_sprite_ext(spr_btn_4,_next_btn_si,(global.sw*0.5)+(_level_name_w*0.5*_scl)+(40*_scl),_nav_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(0,0,155+100*_next_btn_enabled),0.4+(0.5*_next_btn_enabled))


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
	
	// non-standard indicator (left side, under logo)
	if real(obj_ctrlp.postData_nonStandard) >= 1 {
		var _ns_x = (global.sw*0.0)+(50*_scl)
		var _ns_y = _nav_mid_y+(40*_scl)
		var _ns_w = 0.2
		var _ns_h = 0.045
		draw_set_font(fnt_main)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_alpha(0.9)
		var _col_ns_red = make_colour_hsv(2,170,155)
		draw_sprite_ext(spr_circ128,0,_ns_x+(_ns_w*_scl*256),_ns_y,_ns_h*4*_scl,_ns_h*4*_scl,0,_col_ns_red,1)
		draw_sprite_ext(spr_circ128,0,_ns_x+(-_ns_w*_scl*256),_ns_y,_ns_h*4*_scl,_ns_h*4*_scl,0,_col_ns_red,1)
		draw_sprite_ext(spr_sqr512,0,_ns_x,_ns_y,_ns_w*_scl,_ns_h*_scl,0,_col_ns_red,1)
		draw_text_transformed(_ns_x+(-3*_scl),_ns_y,"NON-STANDARD!",0.07*_tscl,0.07*_tscl,0)
		var _ns_icon_x = _ns_x+(_ns_w*_scl*256)
		draw_set_alpha(0.7)
		draw_sprite_ext(spr_info_icon,0,_ns_icon_x,_ns_y,0.13*_scl,0.13*_scl,0,_c_white,0.5)
		draw_set_valign(fa_top)
		if mouse_check_button_pressed(mb_left) && global.show_any_modal <= 0 {
			if scr_mouse_over_button(_ns_x,_ns_y,0.22*_scl,0.1*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				global.show_nonstandard_info = 1
			}
		}
		draw_set_valign(fa_middle)
	}
	
	if global.game_phase < 4 {
		
		draw_set_font(fnt_main)
		
		//btn bgs
		//draw_sprite_stretched_ext(spr_sqr512,2,(global.sw*0.1)-(0.18*_tscl*256),gui_footer_mid_y-(0.12*_tscl*256),0.18*_tscl*512,0.12*_tscl*512,_c_white,0.2) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.1,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.9,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		
		
		draw_sprite_ext(spr_btn_3,3,global.sw*0.1,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(250,150,255),1.2)

		draw_set_alpha(0.6)
		draw_text_transformed(global.sw*0.1,gui_footer_mid_y,"give up",0.11*_tscl,0.11*_tscl,0)
		
		
		
		

		if hint_btn_flash_fd > 0.001 {
			gpu_set_blendmode(bm_add)
			draw_sprite_ext(spr_circ_grad128,0,global.sw*0.9,gui_footer_mid_y,0.5*_scl*(1+(0.8*(1-hint_btn_flash_fd))),0.3*_scl*(1+(0.8*(1-hint_btn_flash_fd))),0,make_colour_hsv(36,230,255),clamp(2*hint_btn_flash_fd,0,0.5))
			draw_sprite_ext(spr_btn_3,2,global.sw*0.9,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(36,230,255),clamp(2*sqr(hint_btn_flash_fd),0,1))
			draw_sprite_ext(spr_btn_3,2,global.sw*0.9,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(36,230,255),clamp(2*sqr(hint_btn_flash_fd),0,1))
			draw_sprite_ext(spr_btn_3,2,global.sw*0.9,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,make_colour_hsv(36,230,255),clamp(2*sqr(hint_btn_flash_fd),0,1))
			
			gpu_set_blendmode(bm_normal)

			draw_set_alpha(clamp(2*hint_pts_pop_fd,0,0.3))
			draw_set_font(fnt_main)
			draw_set_color(c_black)
			draw_text_transformed(global.sw*0.9,gui_footer_mid_y+(-13*_scl)+((-60*_scl)*sqrt(abs(hint_pts_pop_y))),"-200pts",0.14*_tscl*(0.9+(0.1*sqrt(abs(hint_pts_pop_y)))),0.14*_tscl,(pulse_2)*8*hint_btn_flash_fd)
			draw_set_alpha(2*hint_pts_pop_fd)
			draw_set_color(make_colour_hsv(10,180,255))
			draw_text_transformed(global.sw*0.9,gui_footer_mid_y+(-16*_scl)+((-60*_scl)*sqrt(abs(hint_pts_pop_y))),"-200pts",0.14*_tscl*(0.9+(0.1*sqrt(abs(hint_pts_pop_y)))),0.14*_tscl,(pulse_2)*8*hint_btn_flash_fd)
			draw_set_color(_c_white)
			draw_set_alpha(1)
		}
		
		if global.game_hint_letter_used < string_length(secret_word_str) {
			draw_set_alpha(0.6)
		} else {
			draw_set_alpha(0.1)
		}

		draw_sprite_ext(spr_btn_3,2,global.sw*0.9,gui_footer_mid_y,0.25*_scl,0.25*_scl,0,_c_white,1.2)

		draw_text_transformed(global.sw*0.9,gui_footer_mid_y,"hint?",0.11*_tscl,0.11*_tscl,0)

		
		
	} else if global.game_phase = 4 {
		
		draw_set_alpha(0.6)
		
		//btn bgs
		//draw_sprite_stretched_ext(spr_sqr512,2,(global.sw*0.1)-(0.18*_tscl*256),gui_footer_mid_y-(0.12*_tscl*256),0.18*_tscl*512,0.12*_tscl*512,_c_white,0.2) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.1,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.02) 
		//draw_sprite_ext(spr_sqr512,0,global.sw*0.9,gui_footer_mid_y,0.18*_tscl*0.8,0.12*_tscl*0.8,0,_c_white,0.04) 
		
		//draw_text_transformed(global.sw*0.1,gui_footer_mid_y,"play\nanother",0.12*_tscl,0.12*_tscl,0)
		
		if obj_ctrlp.puzzle_is_unlimited != 1 {
			draw_set_font(fnt_main_r)
			draw_set_alpha(0.6)
			draw_set_color(_c_white)
			
			if global.is_landscape <= 0 {
				draw_set_halign(fa_left)
				draw_text_transformed((global.sw*0.0)+(10*_scl)+(-490000*(1-game_finished_fd)),gui_footer_mid_y,"upvote if you enjoyed! :)",0.09*_tscl,0.09*_tscl,0)
				draw_set_halign(fa_right)
				//draw_text_transformed((global.sw*1.0)+(-10*_scl)+(490000*(1-game_finished_fd)),gui_footer_mid_y,"+ join r/Sneakle for more!",0.09*_tscl,0.09*_tscl,0)
			} else { //is landscape
				draw_set_halign(fa_center)
				draw_text_transformed((global.sw*0.5)+(0*_scl),gui_footer_mid_y+(490000*(1-game_finished_fd)),"upvote if you enjoyed :)",0.12*_tscl,0.12*_tscl,0)
			}
			
			draw_set_halign(fa_center)
		}
	}

}

draw_set_halign(fa_center)
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
draw_set_halign(fa_center)
draw_set_font(fnt_main_r)
draw_set_alpha(1)
draw_set_colour(_c_white)



//if keyboard_check(vk_shift) {
//	draw_set_alpha(0.3)
//	draw_text_transformed(global.sw*0.5,(global.sh*1)-(50*_pos_scl),global.current_copy_code,0.07*_tscl,0.07*_tscl,0)
//}



draw_set_font(fnt_main_r)

if global.game_phase <= 0 {
	var _version_scl = 1
	if global.game_phase <= 0 {
		_version_scl = 1.5
	}
	draw_set_font(fnt_main)
	draw_set_alpha(0.5*_version_scl)
	draw_text_transformed(global.sw*0.5,(global.sh*1)+(-35*_version_scl*_scl),"<3 @FermenterGames",0.1*_version_scl*_tscl,0.1*_version_scl*_tscl,0)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.2*_version_scl)
	draw_text_transformed(global.sw*0.5,(global.sh*1)+(-35*_version_scl*_scl),"\n\n\n"+date_datetime_string(GM_build_date)+" - "+string(global.is_ios)+" "+string(global.is_android)+" "+string(global.is_firefox)+" "+string(global.do_basic_input)+" "+string(global.is_mobile),0.07*_version_scl*_tscl,0.07*_version_scl*_tscl,0)
	
	//draw_text_transformed(global.sw*0.5,(global.sh*1)+(-50*_version_scl*_scl),"\n\n\n"+string(global.sw)+"x"+string(global.sh),0.07*_version_scl*_tscl,0.07*_version_scl*_tscl,0)
}

if global.game_phase = 3 {
	if real(obj_ctrlp.option_show_timer) = 1 {
		draw_set_font(fnt_main_r)
		draw_set_alpha(0.3)
		draw_text_transformed(global.sw*0.5,gui_footer_mid_y,scr_format_time(global.game_timer,0),0.12*_tscl,0.12*_tscl,0)
	}
}



draw_set_font(fnt_main)

draw_set_alpha(1)



if global.show_TypeLetters_input_prompt = 1 {
	
	draw_set_alpha(0.97*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
	////Render a div with fancy css
	//var form_container = html_div(undefined, "form-container","Forms","form-container");
	
	////close button
	//var closebtn = html_form(form_container, "closebtn-form");
	//html_submit(closebtn, "closebtn", "Back", !form_is_loading, form_is_loading ? "loading" : "");
	//if html_element_interaction(closebtn)
	//html_submit_closebtn()
	
	////Render a form
	//var form = html_form(form_container, "load-code");
	//html_h3(form, "header", "Load Code")
	//html_field(form, "loadCode", "loadCode", "Enter Code Here", true, "", "");
	//html_submit(form, "submit", "Load", !form_is_loading, form_is_loading ? "loading" : "");
	//if html_element_interaction(form)
	//html_submit_code(form)
	
	
	
	
	
	if global.do_basic_input <= 0 {
		
		//X to close
		draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_any_modal_fd) 
	
	
		if 1=1 {
			draw_set_color(_c_white)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_set_font(fnt_main)
			draw_set_alpha(0.7*global.show_any_modal_fd)	
		
			draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(80*_scl),"Enter the letters you want to use",0.17*_tscl,0.17*_tscl,0)
			draw_set_font(fnt_main_r)
			//draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(140*_scl),"Length needs to be a square number: 9 | 16 | 25 | 36 | 49\nExcess length with be rounded down to nearest square",0.11*_tscl,0.11*_tscl,0)
		
		
			draw_sprite_ext(spr_btn,11,global.sw*0.5,(global.sh*0)+(212*_scl),0.25*_scl,0.25*_scl,0,c_white,0.9*global.show_any_modal_fd) 
	
			draw_set_alpha(0.9*global.show_any_modal_fd)	
			draw_set_font(fnt_main)
			draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(212*_scl),"USE THESE LETTERS",0.12*_tscl,0.12*_tscl,0)
		
			draw_set_alpha(0.7*global.show_any_modal_fd)	
		
			draw_sprite_ext(spr_btn,12,(global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),0.21*_scl,0.21*_scl,0,c_white,0.5*global.show_any_modal_fd) 

			draw_set_font(fnt_main)
			draw_text_transformed((global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),"CLEAR",0.1*_tscl,0.1*_tscl,0)
		
			draw_sprite_ext(spr_btn,12,(global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),0.21*_scl,0.21*_scl,0,c_white,0.5*global.show_any_modal_fd) 
		
			draw_set_font(fnt_main)
			draw_text_transformed((global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),"AUTOFILL\nto next sqr",0.08*_tscl,0.08*_tscl,0)
		
		
		}
	
		//var _kbstatus = keyboard_virtual_status();
		//if (_kbstatus == false) {
		//	keyboard_virtual_show(kbv_type_ascii,kbv_returnkey_continue,kbv_autocapitalize_characters,false)				
		//}
	
		if keyboard_check_released(vk_anykey) {
			alarm[1] = 15 //update input value with _keyboard_string
			//keyboard_string += keyboard_lastchar
		
		}
	
	
		var _keyboard_string = string_upper(string_letters(keyboard_string))
	
	
	
	
		if 1=1 {
		
			var _box_col = c_black
			if global.light_mode = 1 {
				_box_col = c_white	
			}
			draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(global.sh*0)+(150*_scl),0.8*_scl,0.1*_scl,0,_box_col,0.5*global.show_any_modal_fd) 
	
		
			draw_set_color(_c_white)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_left)
			draw_set_font(fnt_main_r)
			draw_set_alpha(0.7*global.show_any_modal_fd)
		
			var _letters_str_w = 100
			var _letters_scl = 1
			var _max_width = 512*0.74*_scl //global.sw*0.7 // 
		
			_letters_str_w = string_width(string(_keyboard_string))
			  
			_letters_scl = min(0.25,(_max_width)/(_letters_str_w+0.01))
		
		
			if pulse_1 > 0.5 {
				_keyboard_string += "|"	
			}
		
			draw_text_transformed((global.sw*0.5)+(-380*0.5*_scl),(global.sh*0)+(150*_scl),_keyboard_string,1*_letters_scl,1*_letters_scl,0)
		
			draw_set_halign(fa_center)
		
		
			_keyboard_string = string_upper(string_letters(_keyboard_string))
		
			var _keyboard_string_l = string_length(_keyboard_string)
			var sqrd_l = 1// sqr(floor(sqrt(_keyboard_string_l)))
			if _keyboard_string_l >= 4 {
				sqrd_l = floor(sqrt(_keyboard_string_l))
			}
			//_letters = string_copy(_letters, 1, sqrd_l); 
		
			draw_set_font(fnt_main)
			draw_set_alpha(0.5*global.show_any_modal_fd)
			//draw_text_transformed((global.sw*0.5)+(-380*0.5*_scl)+(40*_scl),(global.sh*0)+(210*_scl),"length: "+string(_keyboard_string_l)+"\n"+string(sqrd_l)+"x"+string(sqrd_l),0.1*_scl,0.1*_scl,0)
		
			draw_set_alpha(0.7*global.show_any_modal_fd)
		
		
			var _keyboard_string_forgrid = string_copy(_keyboard_string,0,(sqrd_l*sqrd_l))
			draw_set_colour(_c_white)
		
			scr_draw_letter_grid(_keyboard_string_forgrid,(global.sw*0.5),(global.sh*0)+(260*_scl)+(16*sqrd_l*_scl),sqrd_l,32*_scl,0.15*_scl)
		
		
			draw_set_alpha(0.5*global.show_any_modal_fd)
			draw_text_transformed((global.sw*0.5)+(-160*_scl),(global.sh*0)+(245*_scl),string(sqrd_l)+"x"+string(sqrd_l),0.1*_scl,0.1*_scl,0)
			
			draw_text_transformed((global.sw*0.5)+(-160*_scl),(global.sh*0)+(260*_scl),"length: "+string(_keyboard_string_l),0.1*_scl,0.1*_scl,0)
		
		
			var _excess_l = _keyboard_string_l-sqr(sqrd_l)
			if _excess_l > 0 {
			
				var _excess_next = sqr(sqrd_l+1)-_keyboard_string_l
			
			
			
				draw_set_colour(make_colour_hsv(5,160,255))
				draw_set_font(fnt_main)

				draw_text_transformed((global.sw*0.5)+(-160*_scl),(global.sh*0)+(288*_scl),"NEXT SIZE IN:\n"+string(_excess_next),0.1*_scl,0.1*_scl,0)
			
			
				draw_text_transformed((global.sw*0.5)+(0*_scl),(global.sh*0)+(260*_scl)+(16*2*sqrd_l*_scl)+(25*_scl),"EXCESS: "+string_copy(_keyboard_string,(_keyboard_string_l-_excess_l)+1,_excess_l),0.1*_scl,0.1*_scl,0)
			
				
			}
		
			draw_set_colour(c_white)
			draw_set_font(fnt_main)
		
		}
	
	
	
	
		var _submit_letters_now = 0
	
		if global.show_any_modal_fd > 0.5 && keyboard_check_pressed(vk_enter) {
		
			_submit_letters_now = 1
		
		}
	
	
		if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
			//close
			if scr_mouse_over_button(global.sw+(-40*_scl),(40*_scl),0.2*_scl,0.1*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				//close
				html_submit_closebtn()
				global.show_TypeLetters_input_prompt = 0
		
				//keyboard_virtual_hide()
			
			}
		
		
			//ENTER/SUBMIT
			if scr_mouse_over_button(global.sw*0.5,(global.sh*0.0)+(212*_scl),0.4*_scl,0.1*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				//close
				//html_submit_closebtn()
				//global.show_input_prompt = 0
		
				//keyboard_virtual_hide()
			
				//show_debug_message("YUP")
			
				_submit_letters_now = 1
			
			}
			
			//AUTOFILL
			if scr_mouse_over_button((global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),0.19*_scl,0.09*_scl) {
				if sqrd_l <= 6 {
					
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))

				
					global.letter_set_default = "AAAAAAAAAAAAABBBCCCDDDDDDEEEEEEEEEEEEEEEEEEFFFGGGGHHHIIIIIIIIIIIIJJKKLLLLLMMMNNNNNNNNOOOOOOOOOOOPPPQQRRRRRRRRRSSSSSSTTTTTTTTTUUUUUUVVVWWWXXYYYZZ"
	
					//global.letter_set_default = "TSECRETWORDINSIDE"
	
					//global.letter_set_default = "AAAAQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	
					for (var l = 0; l <= string_length(global.letter_set_default)-1; ++l) {
						global.letters_bag[l] = string_char_at(global.letter_set_default,l)
						//show_debug_message(global.letters_bag[l])
					}
				
					//global.letters_bag[0] = "R"	//to avoid undefined in array	
				
					global.letters_bag = array_shuffle(global.letters_bag)
				
				
					var _excess_next = sqr(sqrd_l+1)-_keyboard_string_l
				
					for (var i = 1; i <= _excess_next; ++i) {
						//take first array entry
					
						var _next_letter = array_shift(global.letters_bag)
						array_push(global.letters_bag,_next_letter)
					
						//try again if letter is too common in string already
						if string_count(_next_letter,keyboard_string) > floor(sqrd_l*0.5) {
							show_debug_message("DOING!")
							show_debug_message(_next_letter)
							var _next_letter = array_shift(global.letters_bag)
							array_push(global.letters_bag,_next_letter)
						}
					
						keyboard_string += _next_letter
						//replace letters array end
					
					}
				

					//setElementProperty("CreateTypeLettersInput","value",keyboard_string)
				}
			
			}
		
			//CLEAR
			if scr_mouse_over_button((global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),0.19*_scl,0.09*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				//close
				//html_submit_closebtn()
				//global.show_input_prompt = 0
		
				//keyboard_virtual_hide()
			
				//show_debug_message("YUP")
			
				//_submit_letters_now = 1
			
				keyboard_string = ""
				setElementProperty("CreateTypeLettersInput","value","")
			
			}
		
		
		
			//click on the input area
			if scr_mouse_over_button(global.sw*0.5,(global.sh*0.0)+(150*_scl),0.8*_scl,0.1*_scl) {
			
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			
				if global.is_mobile >= 1 {
					addClassElemID("modalCreateTypeLetters","active")
				}
				setElementProperty("CreateTypeLettersInput","value",string(_keyboard_string))
			
			}
		

		
		}
	
		if _submit_letters_now = 1 {
		
			_keyboard_string = string_upper(string_letters(_keyboard_string))
		
			if string_length(_keyboard_string) >= 4 {
			
				show_debug_message("submit-typed-letters from gui happening");
		
				scr_submit_typed_letters(_keyboard_string);
			
			} else {
				show_debug_message("submit-typed-letters not long enough from gui...");
			}
		
			html_submit_closebtn();	
		
			show_debug_message("resetting keyboard_string")
			keyboard_string = ""	
		
		}
	
	}
	

}



if global.show_PostTitle_input_prompt = 1 {
	
	draw_set_alpha(0.97*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)
	
	
	if global.do_basic_input <= 0 {
		
		//X to close
		draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_any_modal_fd) 
	
	
		if 1=1 {
			draw_set_color(_c_white)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_set_font(fnt_main)
			draw_set_alpha(0.7*global.show_any_modal_fd)	
		
			draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(70*_scl),"Enter a Title for your puzzle and submit.",0.14*_tscl,0.14*_tscl,0)
			draw_set_font(fnt_main_r)
			draw_set_alpha(0.5*global.show_any_modal_fd)	
			draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(95*_scl),"(*This will create a post as your Reddit username!)",0.115*_tscl,0.115*_tscl,0)
			
			draw_set_alpha(0.7*global.show_any_modal_fd)	
			
			//draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(140*_scl),"Length needs to be a square number: 9 | 16 | 25 | 36 | 49\nExcess length with be rounded down to nearest square",0.11*_tscl,0.11*_tscl,0)
		
		
			draw_sprite_ext(spr_btn,11,global.sw*0.5,(global.sh*0)+(212*_scl),0.25*_scl,0.25*_scl,0,c_white,0.9*global.show_any_modal_fd) 
	
			draw_set_alpha(0.9*global.show_any_modal_fd)	
			draw_set_font(fnt_main)
			draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(212*_scl),"[ENTER] TO POST",0.12*_tscl,0.12*_tscl,0)
		
			draw_set_alpha(0.7*global.show_any_modal_fd)	
		
			draw_sprite_ext(spr_btn,12,(global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),0.21*_scl,0.21*_scl,0,c_white,0.5*global.show_any_modal_fd) 

			draw_set_font(fnt_main)
			draw_text_transformed((global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),"CLEAR",0.1*_tscl,0.1*_tscl,0)
		
		
			if obj_ctrlp.username = "FermenterGames" || obj_ctrlp.username = "JigglyStardust" || !global.is_reddit {
				draw_set_alpha(0.7*global.show_any_modal_fd)	
		
				draw_sprite_ext(spr_btn,12,(global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),0.21*_scl,0.21*_scl,0,c_white,0.5*global.show_any_modal_fd) 

				draw_set_font(fnt_main)
				draw_text_transformed((global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),"COPY\npuzzle",0.1*_tscl,0.1*_tscl,0)
		
			}
			
			var _grid_offset_y = 0
			if nonstandard_allowed = 1 || nonstandard_used >= 1 {
				_grid_offset_y = 70
				draw_set_font(fnt_main)
				draw_set_alpha(0.9*global.show_any_modal_fd)
				draw_set_colour(make_colour_hsv(5,120,255))
				draw_text_transformed(global.sw*0.5,(global.sh*0.0)+(280*_scl),"Because you used a non-standard SECRET,\nyour post will be flagged as 'Non-Standard'\nto avoid frustrating players.",0.1*_tscl,0.1*_tscl,0)
			}
		
			draw_set_color(_c_white)
			
			
			draw_set_font(fnt_main)
			draw_set_alpha(0.5*global.show_any_modal_fd)
			//draw_text_transformed((global.sw*0.5)+(-380*0.5*_scl)+(40*_scl),(global.sh*0)+(210*_scl),"length: "+string(_keyboard_string_l)+"\n"+string(sqrd_l)+"x"+string(sqrd_l),0.1*_scl,0.1*_scl,0)
		
			draw_set_alpha(0.7*global.show_any_modal_fd)
		
		
			var _keyboard_string_forgrid = string_copy(global.current_copy_code,0,global.game_grid_size_sqr)
			var _keyboard_string_l = string_length(_keyboard_string_forgrid)
			var sqrd_l = 1// sqr(floor(sqrt(_keyboard_string_l)))
			if _keyboard_string_l >= 4 {
				sqrd_l = floor(sqrt(_keyboard_string_l))
			}
			
			draw_set_colour(_c_white)
		
			scr_draw_letter_grid(_keyboard_string_forgrid,(global.sw*0.5),(global.sh*0)+((260+_grid_offset_y)*_scl)+(16*sqrd_l*_scl),sqrd_l,32*_scl,0.15*_scl)
		
		
			//draw_set_alpha(0.5*global.show_any_modal_fd)
			draw_text_transformed((global.sw*0.5),(global.sh*0)+((260+_grid_offset_y)*_scl)+(16*2*sqrd_l*_scl)+(18*_scl),"secret: "+string(secret_word_str),0.1*_scl,0.1*_scl,0)
		
		
		}
	
		//var _kbstatus = keyboard_virtual_status();
		//if (_kbstatus == false) {
		//	keyboard_virtual_show(kbv_type_ascii,kbv_returnkey_continue,kbv_autocapitalize_characters,false)				
		//}
	
		if keyboard_check_released(vk_anykey) {
			alarm[2] = 15 //update input value with _keyboard_string
			//keyboard_string += keyboard_lastchar
		}
	
	
		var _keyboard_string = keyboard_string //string_upper(string_letters(keyboard_string))
	
	
	
	
		if 1=1 {
		
			var _box_col = c_black
			if global.light_mode = 1 {
				_box_col = c_white	
			}
			draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(global.sh*0)+(150*_scl),0.8*_scl,0.1*_scl,0,_box_col,0.5*global.show_any_modal_fd) 
	
		
			draw_set_color(_c_white)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_left)
			draw_set_font(fnt_main_r)
			draw_set_alpha(0.7*global.show_any_modal_fd)
		
			var _letters_str_w = 100
			var _letters_scl = 1
			var _max_width = 512*0.74*_scl //global.sw*0.7 // 
		
			_letters_str_w = string_width(string(_keyboard_string))
			  
			_letters_scl = min(0.25,(_max_width)/(_letters_str_w+0.01))
		
		
			if pulse_1 > 0.5 {
				_keyboard_string += "|"	
			}
		
			draw_text_transformed((global.sw*0.5)+(-380*0.5*_scl),(global.sh*0)+(150*_scl),_keyboard_string,1*_letters_scl,1*_letters_scl,0)
		
			draw_set_halign(fa_center)
		
		}
			


		var _submit_post_title_now = 0
	
		if global.show_any_modal_fd > 0.5 && keyboard_check_pressed(vk_enter) {
		
			_submit_post_title_now = 1
		
		}
	
	
		if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
			//close
			if scr_mouse_over_button(global.sw+(-40*_scl),(40*_scl),0.2*_scl,0.1*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				//close
				html_submit_closebtn()
				global.show_PostTitle_input_prompt = 0
				
				
				//do something
				//with (obj_ctrl) {
				//	scr_validate_word()
				//}
		
				//keyboard_virtual_hide()
			
			}
		
		
			//ENTER/SUBMIT
			if scr_mouse_over_button(global.sw*0.5,(global.sh*0.0)+(212*_scl),0.4*_scl,0.1*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			
				_submit_post_title_now = 1
			
			}
		
			//CLEAR
			if scr_mouse_over_button((global.sw*0.5)+(160*_scl),(global.sh*0)+(212*_scl),0.19*_scl,0.09*_scl) {
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			
				keyboard_string = ""
				setElementProperty("CreatePostTitleInput","value","")
			
			}
			
			//COPY
			if obj_ctrlp.username = "FermenterGames" || obj_ctrlp.username = "JigglyStardust" || !global.is_reddit {
				if scr_mouse_over_button((global.sw*0.5)+(-160*_scl),(global.sh*0)+(212*_scl),0.19*_scl,0.09*_scl) {
					audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
				
					copyToClipboard(global.current_copy_url)
			
				}
			}
		
		
		
			//click on the input area
			if scr_mouse_over_button(global.sw*0.5,(global.sh*0.0)+(150*_scl),0.8*_scl,0.1*_scl) {
			
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			
				if global.is_mobile >= 1 {
					addClassElemID("modalCreatePostTitle","active")
				}
				setElementProperty("CreatePostTitleInput","value",string(_keyboard_string))
			
			}
		
		}
	
		if _submit_post_title_now = 1 {
		
			//_keyboard_string = string_upper(string_letters(_keyboard_string))
		
			if string_length(_keyboard_string) >= 4 {
			
				show_debug_message("submit-post-title from gui happening");
		
				scr_submit_created_puzzle(_keyboard_string);
			
			} else {
				show_debug_message("submit-post-title not long enough from gui...");
			}
		
			html_submit_closebtn();	
		
			show_debug_message("resetting keyboard_string")
			keyboard_string = ""	
		
		}
	
		if keyboard_check(vk_control) && keyboard_check_pressed(ord("C")) {
			copyToClipboard(global.current_copy_url)
		}
	
	}
	

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
	
	//draw_set_alpha(0.7*global.show_any_modal_fd)
	//draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	//draw_set_alpha(1)
	//draw_set_color(_c_white)
	
	////Render a div with fancy css
	//var archives_container = html_div(undefined, "puzzleMenuWrapper","","archives-container");
	
	//var puzzleMenuHeader = html_div(archives_container, "puzzleMenuHeader","Archives","puzzleMenuHeader");
	//html_h2(puzzleMenuHeader, "puzzleMenuH2","Archives","puzzleMenuH2");

	////close button
	//var closebtn = html_form(puzzleMenuHeader, "closebtn-form");
	//html_submit(closebtn, "closebtn", "Close", !form_is_loading, form_is_loading ? "loading" : "");
	//if html_element_interaction(closebtn)
	//html_submit_closebtn()
	
	
	//var puzzleMenu = html_div(archives_container, "puzzleMenu","i'm the ul","puzzleMenu");
	
	draw_set_alpha(0.97*global.show_any_modal_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,0)
	draw_set_alpha(1)
	draw_set_color(_c_white)

	
	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_any_modal_fd) 
		
	if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
		if scr_mouse_over_button(global.sw+(-40*_scl),(40*_scl),0.2*_scl,0.1*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
			//close
			html_submit_closebtn()
			global.show_options = 0
		}
	}
	
	
	
	draw_set_color(c_white)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_any_modal_fd)
	
	var xx = global.sw*0.5;
	var yy = 170*_scl;
	var spacing = 54*_scl;


	var _total = array_length(global.browser_puzzles);
	//if (_total == 0) exit; // nothing to draw

	

	var _start = global.browser_page * global.browser_limit //max(0, global.browser_cursor);
	var _end   = min(_start + global.browser_limit - 1, array_length(global.browser_puzzles) - 1);//min(global.browser_cursor + global.browser_limit - 1, _total - 1);

	//show_debug_message(global.browser_cursor)
	
	var _bord_col = merge_color(_highlight_blue,c_white,0.2)
	var _highlight_blue_dk = merge_color(_highlight_blue,c_black,0.1)
	var _highlight_blue_dk2 = make_color_hsv(145,220,80)

	for (var i = _start; i <= _end; i++) {
		
		xx = (global.sw*0.5)+((i+1)*-40000*_scl*sqr(1-global.show_any_modal_fd))

	   var p = global.browser_puzzles[i];
		//show_debug_message(p)

	   var _level_name =  p.levelName //+ " (" + p.levelTag + ")";
		
		/*
		var _ldate = p.date_mmdd //scr_format_levelDate(p.levelDate,false)
		//_ldate = string_copy(_ldate,0,string_length(_ldate)-5)
		
		var _ldaywk = p.date_wkday //scr_format_levelDate(p.levelDate,2)
		*/
		
		var _ldate = scr_format_levelDate(p.levelDate,false)
		_ldate = string_copy(_ldate,0,string_length(_ldate)-5)
		
		var _ldaywk = scr_format_levelDate(p.levelDate,2)
		
		
		//var item_y = yy + (i * spacing);
		var item_y = yy + ((i - _start) * spacing); // page offset
    
		draw_sprite_ext(spr_sqr512,0,xx, item_y+(4*_scl),0.6*_scl,0.085*_scl,0,_highlight_blue_dk2,1)
		draw_sprite_ext(spr_sqr512,0,xx, item_y,0.6*_scl,0.085*_scl,0,_bord_col,1)
		draw_sprite_ext(spr_sqr512,0,xx, item_y,0.597*_scl,0.082*_scl,0,_highlight_blue,1)
		draw_sprite_ext(spr_sqr512,0,xx+(9*_scl), item_y,0.45*_scl,0.079*_scl,0,_highlight_blue_dk,1)
		
		
		draw_set_halign(fa_left)
		draw_set_font(fnt_main)
		draw_set_alpha(1*global.show_any_modal_fd)
		
		//
		
		var _max_width = 220//290
		var _letters_str_w = string_width(string(_level_name)+"?")*_scl
			  
		var _letters_scl = min(0.11,(_max_width*_scl)/(_letters_str_w+0.1))
		
		
		if p.levelTag = "daily" { //&& 1=0 {
			draw_text_transformed(xx+(-98*_scl), item_y+(0*_scl), _level_name, _letters_scl*_scl,0.11*_scl,0);
		} else {
		   draw_text_transformed(xx+(-98*_scl), item_y+(-7*_scl), _level_name, _letters_scl*_scl,0.11*_scl,0);
			draw_set_font(fnt_main_r)
			draw_text_transformed(xx+(-98*_scl), item_y+(9*_scl), "by u/"+p.levelCreator, 0.07*_scl,0.07*_scl,0);
		}
		
		
		
		
		//date
		if 1=1 {//p.levelTag = "daily" {
			//draw_set_colour(c_black)
			draw_set_halign(fa_center)
			//draw_set_alpha(0.15*global.show_any_modal_fd)
			//draw_set_font(fnt_main_r)
			////draw_text_transformed(xx+(-107*_scl), item_y+(-1*_scl), "|", 0.13*_scl,0.32*_scl,0);
			//draw_text_transformed(xx+(125*_scl), item_y+(-1*_scl), "|", 0.13*_scl,0.32*_scl,0);
			
			draw_sprite_ext(spr_play_icon,0,xx+(138*_scl), item_y,0.06*_scl,0.06*_scl,0,c_white,0.8)
			
			draw_set_alpha(0.8*global.show_any_modal_fd)
			draw_set_colour(c_white)
			draw_set_font(fnt_main)
			draw_text_transformed(xx+(-130*_scl), item_y+(-10*_scl), _ldaywk, 0.09*_scl,0.09*_scl,0);
			draw_text_transformed(xx+(-130*_scl), item_y+(7*_scl), _ldate, 0.11*_scl,0.11*_scl,0);
			
		}
		
		draw_set_colour(c_white)
		draw_set_halign(fa_center)
		draw_set_font(fnt_main)
		draw_set_alpha(0.9*global.show_any_modal_fd)
		
		if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
			if scr_mouse_over_button(xx, item_y,0.6*_scl,0.09*_scl) {
        
				audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
				var selected = global.browser_puzzles[i]; 
        
				show_debug_message("Clicked: " + selected.postId);

				// load level using postId
				//load_level_from_post(selected.postId);
				
				html_submit_closebtn()
				global.show_options = 0
				
				scr_reddit_reset_post()

				//load post id
				scr_reddit_load_post(selected.postId)
				
			}
		}
		 
	}
	
	
	draw_set_colour(c_white)
	draw_set_halign(fa_center)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.9*global.show_any_modal_fd)
	
	var _pag_y = yy+(spacing*global.browser_limit)+(20*_scl)
	var total_pages = ceil(array_length(global.browser_puzzles) / global.browser_limit);
	
	// Disabled logic
   var can_prev = global.browser_page > 0;
   var can_next = global.browser_page < total_pages - 1 || global.browser_hasMore;

	draw_set_color(can_prev ? _c_white : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(-180*_scl)+(45*_scl), _pag_y,0.16*_scl,0.09*_scl,0,draw_get_color(),0.2)
	draw_text_transformed(xx+(-180*_scl)+(45*_scl), _pag_y, "<< First", 0.1*_scl,0.1*_scl,0);
	
	draw_set_color(can_prev ? _c_white : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(-90*_scl)+(45*_scl), _pag_y,0.16*_scl,0.09*_scl,0,draw_get_color(),0.2)
	draw_text_transformed(xx+(-90*_scl)+(45*_scl), _pag_y, "< Prev", 0.1*_scl,0.1*_scl,0);
	
	draw_set_color(can_next ? _c_white : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(90*_scl)+(-45*_scl), _pag_y,0.16*_scl,0.09*_scl,0,draw_get_color(),0.2)
	draw_text_transformed(xx+(90*_scl)+(-45*_scl), _pag_y, "Next >", 0.1*_scl,0.1*_scl,0);
	
	draw_set_color(can_next ? _c_white : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(180*_scl)+(-45*_scl), _pag_y,0.16*_scl,0.09*_scl,0,draw_get_color(),0.2)
	draw_text_transformed(xx+(180*_scl)+(-45*_scl), _pag_y, "Last >>", 0.1*_scl,0.1*_scl,0);
	
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.3*global.show_any_modal_fd)
	
	
	draw_text_transformed(xx+(0*_scl), _pag_y+(45*_scl), "PAGE "+string(global.browser_page+1), 0.08*_scl,0.08*_scl,0);
	
	
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_any_modal_fd)
	
	
	draw_set_color(c_white)
	
	if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
		if scr_mouse_over_button(xx+(-180*_scl)+(45*_scl), _pag_y,0.16*_scl,0.09*_scl) && can_prev {
			//first
			show_debug_message("Clicked: first");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.browser_page = 0;
		} else if scr_mouse_over_button(xx+(-90*_scl)+(45*_scl), _pag_y,0.16*_scl,0.09*_scl) && can_prev {
			//prev
			show_debug_message("Clicked: prev");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			global.browser_page = max(0, global.browser_page - 1);
		} else if scr_mouse_over_button(xx+(90*_scl)+(-45*_scl), _pag_y,0.16*_scl,0.09*_scl) && can_next {
			//next
			show_debug_message("Clicked: next");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			var next_page = global.browser_page + 1;
			
			// do we already have enough data for next page?
			if (next_page * global.browser_limit < _total) {
				// data already exists, just move page
				global.browser_page = next_page;
				
			} else if (global.browser_hasMore && !global.browser_loading) {
				// Need to load more first
				scr_browser_load_next_page();
				// IMPORTANT: do NOT advance page yet
			}
			 
		} else if scr_mouse_over_button(xx+(180*_scl)+(-45*_scl), _pag_y,0.16*_scl,0.09*_scl) && can_next {
			//last
			show_debug_message("Clicked: last");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//global.browser_page = max(0, total_pages - 1);
			if (global.browser_hasMore) {
			   // We don't have all data yet → keep loading
			   global.browser_pending_last = true;
			   scr_browser_load_next_page();
			} else {
			   // Already fully loaded → go to last page instantly
			   var total_pages = ceil(array_length(global.browser_puzzles) / global.browser_limit);
			   global.browser_page = max(0, total_pages - 1);
			}
		}
	}
	
	
	//draw_text(50, btn_y, "<< First");
	//draw_text(120, btn_y, "< Prev");
	//draw_text(200, btn_y, "Next >");
	//draw_text(280, btn_y, "Last >>");

	// --- Tag filter buttons ---
	var tag_y = 110*_scl;
	//draw_text(50, tag_y, "[All]");
	//draw_text(120, tag_y, "[Daily]");
	//draw_text(200, tag_y, "[Community]");
	
	draw_set_color(c_white)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_left)
	
	
	draw_text_transformed(xx+(-176*_scl), tag_y+(-68*_scl), string_upper("S n e a k l e   A r c h i v e"), 0.14*_scl,0.14*_scl,0);
	
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.5*global.show_any_modal_fd)
	
	draw_text_transformed(xx+(-176*_scl), tag_y+(-32*_scl), "filter by:", 0.1*_scl,0.1*_scl,0);
	
	draw_set_alpha(0.9*global.show_any_modal_fd)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	draw_set_font(fnt_main_r)
	
	
	draw_set_color(global.browser_tag == "" ? _highlight_blue : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(-120*_scl), tag_y,0.22*_scl,0.07*_scl,0,draw_get_color(),(global.browser_tag == "" ? 0.9 : 0.3))
	draw_set_color(global.browser_tag == "" ? c_white : c_gray);
	draw_text_transformed(xx+(-120*_scl), tag_y, "All", 0.1*_scl,0.1*_scl,0);
	
	draw_set_color(global.browser_tag == "daily" ? _highlight_blue : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(-0*_scl), tag_y,0.22*_scl,0.07*_scl,0,draw_get_color(),(global.browser_tag == "daily" ? 0.9 : 0.3))
	draw_set_color(global.browser_tag == "daily" ? c_white : c_gray);
	draw_text_transformed(xx+(-0*_scl), tag_y, "Daily", 0.1*_scl,0.1*_scl,0);
	
	draw_set_color(global.browser_tag == "community" ? _highlight_blue : c_dkgray);
	draw_sprite_ext(spr_sqr512,0,xx+(120*_scl), tag_y,0.22*_scl,0.07*_scl,0,draw_get_color(),(global.browser_tag == "community" ? 0.9 : 0.3))
	draw_set_color(global.browser_tag == "community" ? c_white : c_gray);
	draw_text_transformed(xx+(120*_scl), tag_y, "Community", 0.1*_scl,0.1*_scl,0);
	

	if global.show_any_modal_fd > 0.5 && mouse_check_button_pressed(mb_left) {
		
		if scr_mouse_over_button(xx+(-120*_scl), tag_y,0.22*_scl,0.07*_scl) {
			//all
			show_debug_message("Clicked: all");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			if (global.browser_tag != "") {
		      global.browser_tag = "";
		      global.browser_puzzles = [];
		      global.browser_page = 0;
		      global.browser_cursor = 0;
		      global.browser_hasMore = true;
		      scr_browser_load_next_page();
		   }
		} else if scr_mouse_over_button(xx+(-0*_scl), tag_y,0.22*_scl,0.07*_scl) {
			//daily
			show_debug_message("Clicked: daily");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			if (global.browser_tag != "daily") {
		      global.browser_tag = "daily";
		      global.browser_puzzles = [];
		      global.browser_page = 0;
		      global.browser_cursor = 0;
		      global.browser_hasMore = true;
		      scr_browser_load_next_page();
		   }
		} else if scr_mouse_over_button(xx+(120*_scl), tag_y,0.22*_scl,0.07*_scl) {
			//community
			show_debug_message("Clicked: community");
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			if (global.browser_tag != "community") {
		      global.browser_tag = "community";
		      global.browser_puzzles = [];
		      global.browser_page = 0;
		      global.browser_cursor = 0;
		      global.browser_hasMore = true;
		      scr_browser_load_next_page();
		   }
		}
	}
	
	
	if archive_loading_fd > 0 {
		
		
		draw_set_alpha(0.9*archive_loading_fd)
		draw_set_color(_overlay_blue)
		draw_rectangle(0,tag_y+(30*_scl),global.sw,_pag_y-(35*_scl),0)
		
		draw_set_color(c_white)
		draw_text_transformed(global.sw*0.5,mean(tag_y,_pag_y),"loading...",0.13*_tscl*archive_loading_fd,0.13*_tscl*archive_loading_fd,0)
		
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,mean(tag_y,_pag_y),0.4*_scl*archive_loading_fd,0.4*_scl*archive_loading_fd,global.game_timer_meta*1,_c_white,0.06)
		draw_sprite_ext(spr_sqr512_tile_dotted,0,global.sw*0.5,mean(tag_y,_pag_y),0.5*_scl*archive_loading_fd,0.5*_scl*archive_loading_fd,global.game_timer_meta*-0.88,_c_white,0.06)
		
	}
	
	
}

//leaderboard
if global.show_lb_fd > 0 {
	
	draw_set_alpha(0.97*global.show_lb_fd)
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
	
	draw_set_alpha(0.97*global.show_howto_fd)
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
	
	draw_set_alpha(0.97*global.show_options_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue,_overlay_blue,_overlay_blue,_overlay_blue,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	

	//draw_sprite_ext(spr_howto,0,global.sw/2,(global.sh/2)+(40*_scl*(1-global.show_options_fd)),0.55*_scl,0.55*_scl,0,_c_white,-1+(2*global.show_options_fd)) 
		
	
	
	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,_c_white,0.5*global.show_options_fd) 
	
	draw_set_color(_c_white)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.7*global.show_options_fd)
	draw_text_transformed(global.sw*0.5,(global.sh*0)+(80*_scl),"options",0.2*_tscl,0.2*_tscl,0)
	
	draw_set_alpha(0.3*global.show_options_fd)
	//draw_text_transformed(global.sw*0.5,(global.sh*0)+(140*_scl),"in development :)",0.15*_tscl,0.15*_tscl,0)
	
	//sep line
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(110*_scl),0.65*_scl,0.004*_scl,0,_c_white,0.2*global.show_options_fd) 
	
	
	var _op_b_1_si = 0
	var _op_b_1_str = "DARK MODE"
	var _op_b_2_si = 2
	var _op_b_3_si = 3
	var _op_b_3_col = c_white
	var _op_b_3_col2 = _c_gray
	
	if global.light_mode = 0 {
		_op_b_1_str = "LIGHT MODE (work in progress)"
	}
	
	//obj_ctrlp.option_show_timer = 0
	if real(obj_ctrlp.option_show_timer) = 1 {
		_op_b_2_si = 1
	}
	
	
	if obj_ctrlp.clear_stats_confirm = 1 {
		_op_b_3_si = 4
		_op_b_3_col = c_red
		_op_b_3_col2 = c_maroon
		
	} else if obj_ctrlp.clear_stats_confirm = -1 {
		_op_b_3_si = 3
		_op_b_3_col = c_dkgray
		_op_b_3_col2 = c_dkgray
	}
	
	
	draw_set_color(c_white)
	//btn1
	draw_sprite_ext(spr_btn_8,_op_b_1_si,global.sw*0.5,(160*_scl)+(60*_scl*0)+(5*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_1_si,global.sw*0.5,(160*_scl)+(60*_scl*0),0.25*_scl,0.25*_scl,0,c_white,2*global.show_options_fd)
	
	
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_options_fd)
	draw_text_transformed(global.sw*0.5,(160*_scl)+(60*_scl*0),_op_b_1_str,0.11*_tscl,0.11*_tscl,0)
	
	
	//btn2
	draw_sprite_ext(spr_btn_8,_op_b_2_si,global.sw*0.5,(160*_scl)+(60*_scl*1)+(5*_scl),0.25*_scl,0.25*_scl,0,_c_gray,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_2_si,global.sw*0.5,(160*_scl)+(60*_scl*1),0.25*_scl,0.25*_scl,0,c_white,2*global.show_options_fd)
	
	//btn3
	draw_sprite_ext(spr_btn_8,_op_b_3_si,global.sw*0.5,(160*_scl)+(60*_scl*2)+(5*_scl),0.25*_scl,0.25*_scl,0,_op_b_3_col2,1*global.show_options_fd) 
	draw_sprite_ext(spr_btn_8,_op_b_3_si,global.sw*0.5,(160*_scl)+(60*_scl*2),0.25*_scl,0.25*_scl,0,_op_b_3_col,2*global.show_options_fd) 
	
	
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
		
		if scr_mouse_over_button(global.sw*0.5,(160*_scl)+(60*_scl*0),0.64*_scl,0.08*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//btn1
			
			with (obj_ctrlp) {
				
				option_darkmode = real(option_darkmode)
				option_darkmode = !option_darkmode
				
				if option_darkmode = 0 {
					global.light_mode = 1
				} else if option_darkmode = 1 {
					global.light_mode = 0
				}
			
				option_darkmode = string(option_darkmode)
				api_save_profile({option_darkmode},undefined)
			
			}
			
		}
		
		if scr_mouse_over_button(global.sw*0.5,(160*_scl)+(60*_scl*1),0.64*_scl,0.08*_scl) {
			audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.95+random(0.1))
			//btn1
			
			with (obj_ctrlp) {
				
				option_show_timer = real(option_show_timer)
				option_show_timer = !option_show_timer

				option_show_timer = string(option_show_timer)
				api_save_profile({option_show_timer},undefined)

			}
			

		}
		
		if scr_mouse_over_button(global.sw*0.5,(160*_scl)+(60*_scl*2),0.64*_scl,0.08*_scl) {
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
					
					stat_c_total_started		= "0"
					stat_c_total_finished	= "0"
					stat_c_total_gaveup		= "0"
					stat_c_total_score		= "0"
					stat_c_total_time			= "0"
					stat_c_total_guesses		= "0"
					stat_c_total_hints		= "0"

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
					
					stat_c_total_finished_perc = "0%"
					stat_c_total_score_avg = "0"
					stat_c_total_time_avg =	"0"
					stat_c_total_guesses_avg = "0"

					stat_u_total_finished_perc = "0%"
					stat_u_total_score_avg = "0"
					stat_u_total_time_avg =	"0"
					stat_u_total_guesses_avg = "0"
					
					profile_joined = "0"
					
					api_save_profile({
						stat_d_total_started,
						stat_d_total_finished,
						stat_d_total_gaveup,
						stat_d_total_score,
						stat_d_total_time,
						stat_d_total_guesses,
						stat_d_total_hints,
						stat_c_total_started,
						stat_c_total_finished,
						stat_c_total_gaveup,
						stat_c_total_score,
						stat_c_total_time,
						stat_c_total_guesses,
						stat_c_total_hints,
						stat_u_total_started,
						stat_u_total_finished,
						stat_u_total_gaveup,
						stat_u_total_score,
						stat_u_total_time,
						stat_u_total_guesses,
						stat_u_total_hints,
						profile_joined
					}, function(_status, _ok, _result) {
						//alarm[4] = 60;
					});
				}
			}
		}
	}
	
	scr_draw_stats(STATS_DAILY,(230*_scl)+(110*_scl*0),_scl,1*global.show_options_fd)
	scr_draw_stats(STATS_COMMUNITY,(230*_scl)+(110*_scl*1),_scl,1*global.show_options_fd)
	scr_draw_stats(STATS_UNLIMITED,(230*_scl)+(110*_scl*2),_scl,1*global.show_options_fd)
}


//non-standard info modal
if global.show_nonstandard_info_fd > 0 {
	
	draw_set_alpha(0.97*global.show_nonstandard_info_fd)
	draw_rectangle_color(0,0,global.sw,global.sh,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,_overlay_blue_dk,0)
	draw_set_alpha(1)
	draw_set_color(c_white)
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_nonstandard_info_fd)

	
	draw_sprite_ext(spr_circ512,0,(global.sw*0.5)+(-0.44*256*_scl),(global.sh*0)+(100*_scl)+(-150*(1-global.show_nonstandard_info_fd)*_scl),0.08*_scl,0.08*_scl,0,make_colour_hsv(2,170,155),2*global.show_nonstandard_info_fd)
	draw_sprite_ext(spr_circ512,0,(global.sw*0.5)+(0.44*256*_scl),(global.sh*0)+(100*_scl)+(-150*(1-global.show_nonstandard_info_fd)*_scl),0.08*_scl,0.08*_scl,0,make_colour_hsv(2,170,155),2*global.show_nonstandard_info_fd)
	draw_sprite_ext(spr_sqr512,0,global.sw*0.5,(global.sh*0)+(100*_scl)+(-150*(1-global.show_nonstandard_info_fd)*_scl),0.44*_scl,0.08*_scl,0,make_colour_hsv(2,170,155),2*global.show_nonstandard_info_fd)
	draw_text_transformed(global.sw*0.5,(global.sh*0)+(100*_scl)+(-150*(1-global.show_nonstandard_info_fd)*_scl),"! NON-STANDARD !",0.15*_tscl,0.15*_tscl,0)
	
	draw_text_transformed(global.sw*0.5,(global.sh*0)+(180*_scl)+(120*(1-global.show_nonstandard_info_fd)*_scl),"What's a NON-STANDARD puzzle?",0.17*_tscl,0.17*_tscl,0)

	draw_set_valign(fa_top)
	draw_set_font(fnt_main_r)
	draw_set_alpha(0.7*global.show_nonstandard_info_fd)
	//draw_text_ext_transformed(global.sw*0.5,(global.sh*0)+(170*_scl)+(120*(1-global.show_nonstandard_info_fd)*_scl),"TL;DR\nThis puzzle allows NON-STANDARD guesses\n-\nUsually your guesses are limited to only standard dictionary words. However, in a NON-STANDARD puzzle your guesses can be uncommon words, proper nouns, or ANYTHING the Puzzle's author decides.\n\nYou get more guess flexibility, but the secret word may be extra weird.\n\nGood luck! :)",200,380/0.14,0.14*_tscl,0.14*_tscl,0)
	draw_text_ext_transformed(global.sw*0.5,(global.sh*0)+(230*_scl)+(120*(1-global.show_nonstandard_info_fd)*_scl),"In a NON-STANDARD puzzle, the author's Secret Word could be ANYTHING - short words, proper nouns, non-English words, and non-dictionary words are all allowed!\n-\nThis also means that your guesses aren't limited to the dictionary either. Guess to your heart's content!\n\nGood luck! :)",210,400/0.15,0.15*_tscl,0.14*_tscl,0)

	draw_set_valign(fa_middle)
	var _ok_btn_y = (global.sh*0)+(600*_scl)+(120*(1-global.show_nonstandard_info_fd)*_scl)
	draw_set_font(fnt_main)
	draw_set_alpha(0.9*global.show_nonstandard_info_fd)
	draw_sprite_ext(spr_btn,11,global.sw*0.5,_ok_btn_y+(5*_scl),0.27*_scl,0.27*_scl,0,_c_gray,1*global.show_nonstandard_info_fd)
	draw_sprite_ext(spr_btn,11,global.sw*0.5,_ok_btn_y,0.27*_scl,0.27*_scl,0,c_white,2*global.show_nonstandard_info_fd)
	draw_set_alpha(0.95*global.show_nonstandard_info_fd)
	draw_text_transformed(global.sw*0.5,_ok_btn_y,"GOT IT!",0.13*_tscl,0.13*_tscl,0)

	

	//X to close
	draw_sprite_ext(spr_sqr512,4,global.sw+(-40*_scl),(40*_scl),0.05*_scl,0.05*_scl,45,c_white,0.5*global.show_nonstandard_info_fd)
	
	if mouse_check_button_pressed(mb_left) && global.show_nonstandard_info_fd > 0.5 {
		audio_play_sound(snd_mm_click_003,0,0,0.14,0,0.55+random(0.1))
		html_submit_closebtn()
		global.show_nonstandard_info = 0
	}
	
}


//show_submitting_post
if global.show_submitting_post > 0 {
	
	draw_set_alpha(0.97*global.show_submitting_post)
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
	draw_text_ext_transformed(global.sw*0.1, global.sh*0.1, $"{info_ds_map_str}\n\n\nUser: {obj_ctrlp.username}\nscore_guesses: {obj_ctrlp.score_guesses}\nscore_hints: {obj_ctrlp.score_hints}\nscore_time: {obj_ctrlp.score_time}\nscore_combined: {obj_ctrlp.score_combined}\n\n\nSTATS\nstarted: {obj_ctrlp.stat_d_total_started}\nfinished: {obj_ctrlp.stat_d_total_finished}\nguesses: {obj_ctrlp.stat_d_total_guesses}\nscore: {obj_ctrlp.stat_d_total_score}\n\n\n"+string(_postData_str), 140, 2000,0.1*_tscl,0.05*_tscl,0)

	if _lb_str != "" {
		draw_set_halign(fa_right)
		//draw_text_ext_transformed(global.sw*0.9, global.sh*0.1,string(_lb_str), 140, 2000,0.1*_tscl,0.1*_tscl,0)
	}

	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)	
}

