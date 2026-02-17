///
// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_leaderboard_list_draw(xx,yy,yo,para,scl,alp,extras,single_id=-1) {
	if (live_call(argument0,argument1,argument2,argument3,argument4,argument5,argument6,argument7)) return live_result;
	
	
	//show_debug_message()
	
	//para = 1
	//scl = 0.68
	
	var mm_uxfd = alp
	
	//scl = 0.4
	
	
	var hud_scl = obj_ctrl.gui_sz_scl
	

	
	
	
	//var v_pu_parallax = 0
	//var v_spr_btns = global.spr_btns
	
	var hud_scl_bkup = hud_scl
	
	hud_scl *= scl//1
	
	var _fnt_scl = 1
	var _fnt_scl_lb = 6
	
	var _bounty_card_y_scrolloffset = yo//bounty_card_y_scrolloffset_fd
	var bounty_card_para = para//0.2
	var bounty_card_para_y = para*0.2
	
	var bounty_card_x = xx+(-8*hud_scl) //9.5*(global.sw/16)
	var bounty_card_y = yy+yo//(3*(global.sh/9))+_bounty_card_y_scrolloffset
	
	
	var bounty_card_main_alp = alp
	var bounty_card_extras = extras
	var bounty_single_id = single_id
	
	var _bounty_card_y_offset2 = 0
	
	var _menu_fd = alp
	
	var lbmenu_fd = global.show_lb_fd

	var lb_variant_hovered = 1
	var lb_variant_hovered_fd = 1
	var lbmenu_which = 1
	var lbmenu_variant1_fd = global.show_lb_fd
	
	var _green_check_col = make_color_hsv(100,255,210)
	var _green_check_txt = make_color_hsv(100,215,250)
	
	var COL_MENU_AQUA2 = _green_check_txt //make_color_hsv(110,60,230)
	
	
	with (obj_ctrl) {
		
	var lbmenu = 1
		
	if 1=1 {//lbmenu_fd > 0 { 

    gpu_set_blendmode(bm_normal)
    draw_set_font(fnt_main)
    
    draw_set_alpha(lbmenu_fd*.95*_menu_fd)
    //draw_set_colour(COL_GRAY15)
    //draw_rectangle(0,0,room_width,room_height,0)
    draw_set_colour(c_white)
    
    //gpu_set_blendmode(bm_normal)

    draw_set_alpha(.9*_menu_fd)//1*(game_over_fd2))
    draw_set_halign(fa_center)
    draw_set_valign(fa_middle)
    draw_set_colour(COL_MENU_AQUA2)
    //draw_set_colour(c_white)
    //draw_text_transformed((bounty_card_x),bounty_card_y+30+(-1000*(1-lbmenu_fd)),string("R A N K I N G S"),0.9*hud_scl,0.9*hud_scl,0)
    
    draw_set_colour(c_white)
    
    draw_set_alpha(1*lbmenu_fd)
    

    
    draw_set_alpha(.8*lbmenu_fd*_menu_fd)
    draw_set_font(fnt_main)
    draw_set_halign(fa_center)
   
	
	var _lb_entries_top_y = 225
	var _lb_entries_left_x = -500
	var _lb_you_indication = "YOU >"
	
	
	var _lb_title = "- "+(string_upper(obj_ctrlp.postData_levelName))+" -"
	
	//_lb_title = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	var _lb_title_scl = 1
	if string_width(_lb_title) > 1700 {//string_width(_lb_title) {
		_lb_title_scl = 1700/string_width(_lb_title)
	}
	
	//full bg
	//draw_sprite_ext(spr_titlebg,0,(bounty_card_x),(bounty_card_y)+((512+48+-96)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),2.5*hud_scl,8.75*hud_scl,0,merge_color(COL_MENU_AQUA3_DK,COL_GRAY5,0.7),0.4*(-20+(21*lbmenu_fd))*_menu_fd)
  
	//title bg
	//gpu_set_blendmode(bm_add)
	//draw_sprite_ext(spr_titlebg,0,(bounty_card_x),(bounty_card_y)+((-0)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),2.5*hud_scl,1.5*hud_scl,0,COL_MENU_AQUA2,.5*lbmenu_fd*_menu_fd)
   //gpu_set_blendmode(bm_add)
	//gpu_set_blendmode(bm_normal)
	//draw_sprite_ext(spr_titlebg,0,(bounty_card_x),(bounty_card_y)+((-0)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),2.3*hud_scl,1.4*hud_scl,0,c_black,.5*lbmenu_fd*_menu_fd)
	//draw_sprite_ext(spr_titlebg,0,(bounty_card_x),(bounty_card_y)+((-0)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),2.5*hud_scl,1.4*hud_scl,0,COL_MENU_AQUA3_DK,.5*lbmenu_fd*_menu_fd)
	
	
	draw_set_colour(_green_check_txt)
	gpu_set_blendmode(bm_add)
	draw_set_alpha((0.7)*lbmenu_fd*_menu_fd)
	
   draw_text_transformed((bounty_card_x)+(0*hud_scl*(1-lbmenu_fd)),(bounty_card_y)+((7)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),_lb_title,0.5*hud_scl*_lb_title_scl*_fnt_scl,0.5*hud_scl*_lb_title_scl*_fnt_scl,0)

	gpu_set_blendmode(bm_normal)
	
	
	draw_set_alpha(.5)
	if !instance_exists(obj_ctrlp) {
		draw_text_transformed((bounty_card_x),(bounty_card_y)+((150+120)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),"---",0.5*hud_scl,0.5*hud_scl,0)
	} else {
		if obj_ctrlp.lb_entry[1,1] = "-" {
			
			if 1=1 {
				draw_text_transformed((bounty_card_x),(bounty_card_y)+((150+120)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),"loading...",0.5*hud_scl,0.5*hud_scl,0)
			}
			//draw_sprite_ext(spr_nile_symbol_simple,4,(bounty_card_x),(bounty_card_y)+((150+300)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),0.6*hud_scl,0.6*hud_scl,timey*-3,draw_get_color(),0.5)
  
		}
	}
	
	draw_set_alpha(.8*lbmenu_fd*_menu_fd)
	 
    
	if instance_exists(obj_ctrlp) {
	
	

	
   draw_set_alpha(1*lbmenu_fd)
	
	
	if 1=1 { //table headers
		
		var ii = 1
		
		draw_set_font(fnt_main_r)
		draw_set_colour(COL_MENU_AQUA2)

		draw_set_halign(fa_left)
		draw_set_alpha(.5*lbmenu_fd*_menu_fd)
					
			
		//draw_text_transformed((bounty_card_x)+((_lb_entries_left_x)*hud_scl),(bounty_card_y)+((_lb_entries_top_y-18-55)*hud_scl)+(500*ii*hud_scl*(1-lbmenu_fd)),lexicon_text("text.gui.LBRank"),0.22*hud_scl*_fnt_scl,0.22*hud_scl*_fnt_scl*lbmenu_fd,0)
	      
		//draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+100)*hud_scl),(bounty_card_y)+((_lb_entries_top_y-18-55)*hud_scl)+(500*ii*hud_scl*(1-lbmenu_fd)),lexicon_text("text.gui.LBName"),0.22*hud_scl*_fnt_scl,0.22*hud_scl*_fnt_scl*lbmenu_fd,0)
	      
			
		//draw_set_halign(fa_left)
		//if lbmenu_which = 9 || lbmenu_which = 10 { //endless or race
		//	draw_text_transformed((bounty_card_x)+(350*hud_scl),(bounty_card_y)+(((_lb_entries_top_y-18-4-55)+0)*hud_scl)+(500*ii*hud_scl*(1-lbmenu_fd)),lexicon_text("text.gui.LBTime"),0.22*hud_scl*_fnt_scl,0.22*hud_scl*_fnt_scl*lbmenu_fd,0)
		//} else {
		//	draw_text_transformed((bounty_card_x)+(350*hud_scl),(bounty_card_y)+(((_lb_entries_top_y-18-4-55)+0)*hud_scl)+(500*ii*hud_scl*(1-lbmenu_fd)),lexicon_text("text.gui.LBScore"),0.22*hud_scl*_fnt_scl,0.22*hud_scl*_fnt_scl*lbmenu_fd,0)
		//}
	
	}
    
   if lbmenu_variant1_fd > 0 {
    
      draw_set_alpha(.7*lbmenu_fd*_menu_fd)
      draw_set_halign(fa_center)
      draw_set_colour(COL_MENU_AQUA2)
		draw_set_font(fnt_main)
		
		if lb_variant_hovered = 1 {
			draw_set_colour(c_white)
			draw_set_alpha(.9*lbmenu_fd*_menu_fd)
			//draw_set_font(global.fnt_main_b)
		}
		
		//draw_sprite_ext(spr_pill256,4,(bounty_card_x),(bounty_card_y)+((96)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),1*hud_scl,1*hud_scl,0,merge_color(COL_MENU_AQUA3_DK,COL_GRAY5,0.5),1*(-20+(21*lbmenu_fd))*_menu_fd)
		////draw_sprite_ext(spr_titlebg,0,(bounty_card_x),(bounty_card_y)+((96)*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),1*hud_scl,0.5*hud_scl,0,merge_color(COL_MENU_AQUA3_DK,COL_GRAY5,0.5),1*(-20+(21*lbmenu_fd))*_menu_fd)
		
		var lb_variant_title_str = ""

		lb_variant_title_str = "Top Scores"
		
		
		var lb_variant_title_str_scl = 1
		var lb_variant_title_str_w = string_width(lb_variant_title_str)
		
		if lb_variant_title_str_w > 1250 {
			lb_variant_title_str_scl = 1250/lb_variant_title_str_w
		}
		
      //if lbmenu_which >= 1 {
         draw_text_transformed((bounty_card_x),(bounty_card_y)+(98*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),lb_variant_title_str,0.25*hud_scl*_fnt_scl*lb_variant_title_str_scl,0.25*hud_scl*_fnt_scl*lb_variant_title_str_scl,0)
      //} else {
      //   draw_text_transformed((bounty_card_x),(bounty_card_y)+(98*hud_scl)+(-0*hud_scl*(1-lbmenu_fd)),string("TOP TIMES"),0.25*hud_scl,0.25*hud_scl,0)
      //}
		
		draw_set_font(fnt_main)
        
    
		//sep vert line
      draw_set_colour(c_white)
      draw_set_alpha(0.1*lbmenu_fd*_menu_fd) 
      draw_rectangle((bounty_card_x)+((300+(-1))*hud_scl),(bounty_card_y)+((_lb_entries_top_y-47)*hud_scl)+(500*hud_scl*(1-lbmenu_fd)),(bounty_card_x)+((300+(1))*hud_scl),(bounty_card_y)+((_lb_entries_top_y-50+1540)*hud_scl)+(500*hud_scl*(1-lbmenu_fd)),0)
    
	 
		var _lb_entry_is_me = 0
		

	 
      for (var ii=1; ii<=3; ii+=1) {
	      if ii = 1 {draw_set_color(c_yellow)}
	      else if ii = 2 {draw_set_color(make_color_hsv(110,60,230))}
	      else if ii = 3 {draw_set_color(c_orange)}
			
			
			var _lb_entry_name = string(obj_ctrlp.lb_entry[ii,2])
			var _lb_entry_rank = string(obj_ctrlp.lb_entry[ii,1])+"."
			_lb_entry_is_me = 0 //reset
			if obj_ctrlp.username = obj_ctrlp.lb_entry[ii,2] {
				_lb_entry_is_me = 1
				//_lb_entry_rank = "> "+string(_lb_entry_rank)
			}
			
	      draw_set_alpha(1*lbmenu_fd*_menu_fd)
	      draw_set_font(fnt_main)
	      draw_set_halign(fa_left)
	      //draw_text_transformed((bounty_card_x)+70,((bounty_card_x)-81)+(32*(ii-1))+(500*(1-lbmenu_fd)),string(ii)+". "+"ACEYPOO92",1.15,1.15,0)
			
			
			//draw_sprite_ext(spr_titlebg,1,(bounty_card_x),(bounty_card_y)+(_lb_entries_top_y*hud_scl)+(-5*hud_scl)+(92*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),2.5*hud_scl,0.65*hud_scl,0,draw_get_color(),0.15*lbmenu_fd*_menu_fd)
  
			if _lb_entry_is_me = 1 {
				draw_set_halign(fa_right)
				var _col_bkup = draw_get_colour()
				draw_set_colour(merge_color(_col_bkup,c_white,0.5+(0.4*obj_ctrl.pulse_3)))
				draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+(_lb_entry_is_me*-20)+(3*obj_ctrl.pulse_1))*hud_scl),(bounty_card_y)+((_lb_entries_top_y+0)*hud_scl)+(112*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(_lb_you_indication),0.25*hud_scl,0.25*hud_scl,0)
				draw_set_halign(fa_left)
				draw_set_colour(_col_bkup)
			}
			draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+(_lb_entry_is_me*-0))*hud_scl),(bounty_card_y)+(_lb_entries_top_y*hud_scl)+(112*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),_lb_entry_rank,0.45*hud_scl,0.45*hud_scl,0)
	      
			draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+100)*hud_scl),(bounty_card_y)+(_lb_entries_top_y*hud_scl)+(112*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(_lb_entry_name),0.45*hud_scl,0.45*hud_scl,0)
	      
	      //obj_ctrlp.steam_name_new[i]
	      draw_set_alpha(.8*lbmenu_fd*_menu_fd)
	      draw_set_font(fnt_main)
	      draw_set_halign(fa_left)
	      //draw_text_transformed((bounty_card_x)+95,((bounty_card_x)-80)+(32*(ii-1))+(500*(1-lbmenu_fd)),"1:33.77",.68,.68,0)
	      draw_text_transformed((bounty_card_x)+(350*hud_scl),(bounty_card_y)+((_lb_entries_top_y-5)*hud_scl)+(112*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(obj_ctrlp.lb_entry[ii,3]),.45*hud_scl,.45*hud_scl,0)
      }
		
		
        
      for (var ii=4; ii<=15; ii+=1) {
			
	      draw_set_colour(c_white)
			
			var _lb_bg_ban_alp = 0.05
			var _lb_entry_name = string(obj_ctrlp.lb_entry[ii,2])
			var _lb_entry_rank = string(obj_ctrlp.lb_entry[ii,1])+"."
			_lb_entry_is_me = 0 //reset
			if obj_ctrlp.username = obj_ctrlp.lb_entry[ii,2] {
				_lb_entry_is_me = 1
				//_lb_entry_rank = "> "+string(_lb_entry_rank)
				draw_set_colour(make_color_hsv(110,60,230))
				_lb_bg_ban_alp = 0.15
			}

	      draw_set_font(fnt_main)
	      draw_set_halign(fa_left)
	      draw_set_alpha(.8*lbmenu_fd*_menu_fd)
			
			//draw_sprite_ext(spr_titlebg,1,(bounty_card_x),(bounty_card_y)+((_lb_entries_top_y+80)*hud_scl)+(-3*hud_scl)+(62*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),2.5*hud_scl,0.42*hud_scl,0,draw_get_color(),_lb_bg_ban_alp*lbmenu_fd*_menu_fd)

			if _lb_entry_is_me = 1 {
				draw_set_halign(fa_right)
				var _col_bkup = draw_get_colour()
				draw_set_colour(merge_color(_col_bkup,c_white,0.5+(0.4*obj_ctrl.pulse_3)))
				draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+(_lb_entry_is_me*-20)+(3*obj_ctrl.pulse_1))*hud_scl),(bounty_card_y)+((_lb_entries_top_y+80)*hud_scl)+(92*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(_lb_you_indication),0.23*hud_scl,0.23*hud_scl,0)
				draw_set_halign(fa_left)
				draw_set_colour(_col_bkup)
			}
			
			//scale rank to fit
			//if ii mod 2 = 0 {_lb_entry_rank = string(real(obj_ctrlp.steam_rank[ii-1])*1233)+"."}
			var _lb_entry_rank_w = string_width(_lb_entry_rank)
			var _lb_entry_rank_scl = 1
			if _lb_entry_rank_w > 340 {
				_lb_entry_rank_scl = 340/_lb_entry_rank_w
			}
			
			draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+(_lb_entry_is_me*-0))*hud_scl),(bounty_card_y)+((_lb_entries_top_y+80)*hud_scl)+(92*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),_lb_entry_rank,0.35*hud_scl*_lb_entry_rank_scl,0.35*hud_scl*_lb_entry_rank_scl,0)
	      
			draw_text_transformed((bounty_card_x)+((_lb_entries_left_x+100)*hud_scl),(bounty_card_y)+((_lb_entries_top_y+80)*hud_scl)+(92*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(_lb_entry_name),0.35*hud_scl,0.35*hud_scl,0)
	      


	      draw_set_font(fnt_main)
	      draw_set_halign(fa_left)
	      draw_set_alpha(.6*lbmenu_fd*_menu_fd)
	      draw_text_transformed((bounty_card_x)+(350*hud_scl),(bounty_card_y)+(((_lb_entries_top_y-4)+80)*hud_scl)+(92*hud_scl*(ii-1))+(500*ii*hud_scl*(1-lbmenu_variant1_fd)),string(obj_ctrlp.lb_entry[ii,3]),.35*hud_scl,.35*hud_scl,0)
      }
    
   } //end of variant 1
    

	
	}
    
    draw_set_colour(c_white)
    draw_set_alpha(1)

	}
	}
	
	
	//hud_scl = hud_scl_bkup
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	

	
	
}