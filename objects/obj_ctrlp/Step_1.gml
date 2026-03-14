///

if(mouse_check_button_pressed(mb_any)) focus_window()

global.game_timer_meta += 1


//global.is_reddit = 1


if just_submitted_score > 0 {
	just_submitted_score -= 0.005	
}

if global.show_lb >= 1 {
	
	//if lb_variant_hovered >= 1 && lb_switch_time > 0 {
	//	lb_switch_time = lb_switch_time_max
	//}
	
	lb_variant_hovered = 0
	
	var _in_top_15 = 0
	if lb_your_rank != -1 && lb_your_rank <= 15 {
		_in_top_15 = 1
		lbmenu_which_variant = 1
		//lbmenu_variant1_fd = 1
		//lbmenu_variant2_fd = 0
		lb_switch_time = lb_switch_time_max-1
	}

	if _in_top_15 = 0 {
	   if lb_switch_time > 0 {
	      lb_switch_time -= 1
	   } else {
		

			if lb_switch_time = -2 { //cycle backwards if -2 (set from left key or gp padl)
		
		      if lbmenu_which_variant = 1 {
		         lbmenu_which_variant = 2
		      } else {
		         lbmenu_which_variant = 1
		      }
		
			} else { //cycle forwards
			
				if lbmenu_which_variant = 1 {
		         lbmenu_which_variant = 2
		      } else {
		         lbmenu_which_variant = 1
		      }
			
			}
		
			lb_switch_time = lb_switch_time_max
		
			//audio_play_sound_on(obj_ctrlp.sfx_mm,snd_mm_tick_001,0,0,0.08,,0.8+(0.25*lbmenu_which_variant))
			audio_play_sound(snd_mm_toggle_on,0,0,0.3*(0.4+(0.3*lb_variant_hovered)),,0.8+(0.25*lbmenu_which_variant))
			audio_play_sound(snd_mm_tick_001,0,0,0.05*(0.4+(0.3*lb_variant_hovered)),,0.2+(0.2*lbmenu_which_variant))
		
	   }
	
	}
	 
	 
	//debug just 1
	//lbmenu_which_variant = 1


   //lbmenu_which_fd = lerp(lbmenu_which_fd,lbmenu_which,.4)
    
   if lbmenu_which_variant = 1 {
      lbmenu_variant1_fd = lerp(lbmenu_variant1_fd,1,.3)
      lbmenu_variant2_fd = lerp(lbmenu_variant2_fd,0,.4)
   } else if lbmenu_which_variant = 2 {
      lbmenu_variant1_fd = lerp(lbmenu_variant1_fd,0,.4)
      lbmenu_variant2_fd = lerp(lbmenu_variant2_fd,1,.3)
   }
    
   //if lbmenu_fd < 1 {
	//	if instance_exists(obj_rankings) {
	//		if obj_rankings.steam_score[0] != "-" { //if first entry is still blank, don't show lbs
	//			lbmenu_fd = lerp(lbmenu_fd,1,.4)
	//		}
	//	}
   //}
   
} else {
   //if lbmenu_fd > 0 {
   //   lbmenu_fd = lerp(lbmenu_fd,0,.4)
   //}
}
