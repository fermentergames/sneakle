///
function scr_draw_stats(_which_stats,_panel_mid_y,_scl,_alp){
	if (live_call(argument0,argument1,argument2,argument3)) return live_result;
	
	var _panel_bottom_y = gui_panel_bottom_y
	var _panel_top_y = gui_panel_top_y
	//var _panel_mid_y = gui_panel_mid_y

	var _panel_ht = abs(_panel_bottom_y-_panel_top_y)
	
	var _tscl = _scl
	
	var _c_white = c_white
	if global.light_mode = 1 {
		_c_white = c_black
		_alp *= 1.2
	}
	
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
		
	draw_set_color(c_black)
	draw_set_alpha(0.15*_alp)
	if global.light_mode = 1 {
		draw_set_color(c_white)	
		draw_set_alpha(0.45*_alp)
	}
		
		
	var _stat_h = 50
	var _stat_y = 0.7//+((1-game_finished_fd)*-0.2)
		
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
	draw_set_alpha(0.5*_alp)
	draw_set_font(fnt_main)
	var _stats_title_str = "- Your Daily Stats -"
	if _which_stats = STATS_UNLIMITED {
		_stats_title_str = "- Your Unlimited Stats -"
	} else if _which_stats = STATS_COMMUNITY {
		_stats_title_str = "- Your Community Stats -"
	}
		
		
	draw_text_transformed((global.sw/2)+(0*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-_stat_h+17)*_scl),_stats_title_str,0.1*_tscl,0.1*_tscl,0)

	var _stat_str
	_stat_str[1][1] = "played"
	_stat_str[2][1] = "finished"
	_stat_str[3][1] = "avg guesses"
	_stat_str[4][1] = "avg time"
	_stat_str[5][1] = "avg score"


	if _which_stats = STATS_UNLIMITED {
		_stat_str[1][2] = obj_ctrlp.stat_u_total_started //"25"
		_stat_str[2][2] = obj_ctrlp.stat_u_total_finished_perc //"95%"
		_stat_str[3][2] = obj_ctrlp.stat_u_total_guesses_avg //"3.2"
		_stat_str[4][2] = obj_ctrlp.stat_u_total_time_avg //"1:24"
		_stat_str[5][2] = obj_ctrlp.stat_u_total_score_avg //"652"
	} else if _which_stats = STATS_DAILY {
		_stat_str[1][2] = obj_ctrlp.stat_d_total_started //"25"
		_stat_str[2][2] = obj_ctrlp.stat_d_total_finished_perc //"95%"
		_stat_str[3][2] = obj_ctrlp.stat_d_total_guesses_avg //"3.2"
		_stat_str[4][2] = obj_ctrlp.stat_d_total_time_avg //"1:24"
		_stat_str[5][2] = obj_ctrlp.stat_d_total_score_avg //"652"
	} else if _which_stats = STATS_COMMUNITY {
		_stat_str[1][2] = obj_ctrlp.stat_c_total_started //"25"
		_stat_str[2][2] = obj_ctrlp.stat_c_total_finished_perc //"95%"
		_stat_str[3][2] = obj_ctrlp.stat_c_total_guesses_avg //"3.2"
		_stat_str[4][2] = obj_ctrlp.stat_c_total_time_avg //"1:24"
		_stat_str[5][2] = obj_ctrlp.stat_c_total_score_avg //"652"
	}
			
		
	draw_set_alpha(0.7*_alp)
	draw_set_font(fnt_main_r)
	draw_text_transformed((global.sw/2)+(-0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[1][1],		0.08*_tscl,0.08*_tscl,0)
	draw_text_transformed((global.sw/2)+(-0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[2][1],		0.08*_tscl,0.08*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.00*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[3][1],		0.08*_tscl,0.08*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[4][1],		0.08*_tscl,0.08*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((-10)*_scl),	_stat_str[5][1],		0.08*_tscl,0.08*_tscl,0)
		
	draw_set_alpha(0.5*_alp)
	draw_set_font(fnt_main)
	draw_text_transformed((global.sw/2)+(-0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[1][2],		0.19*_tscl,0.19*_tscl,0)
	draw_text_transformed((global.sw/2)+(-0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[2][2],		0.19*_tscl,0.19*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.00*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[3][2],		0.19*_tscl,0.19*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.35*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[4][2],		0.19*_tscl,0.19*_tscl,0)
	draw_text_transformed((global.sw/2)+( 0.70*_stat_sw_1*_scl),(_panel_mid_y)+(_panel_ht*_stat_y)+((17)*_scl),	_stat_str[5][2],		0.19*_tscl,0.19*_tscl,0)
		
}