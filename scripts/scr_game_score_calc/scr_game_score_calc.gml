///
function scr_game_score_calc(){
if (live_call()) return live_result;

	global.game_score_total = 0 //reset
	
	//Time score: (1-(timer/5 min))*100
	//((10-(Guesses+hints))*100)+(time_score)
	
	var _time_bonus_length_cap = 5*60*60 //5 minutes
	
	//2:40 = 66 //for 666
	
	global.game_score_time_bonus = ceil((1-(global.game_timer/_time_bonus_length_cap))*100)
	global.game_score_time_bonus = clamp(global.game_score_time_bonus*(1-global.gave_up),0,9999)
	show_debug_message("global.game_score_time_bonus: "+string(global.game_score_time_bonus))

	global.game_score_guesses_and_hints = ceil((10-(guesses_count+global.game_hints_used))*100)
	global.game_score_guesses_and_hints = clamp(global.game_score_guesses_and_hints*(1-global.gave_up),0,9999)
	show_debug_message("global.game_score_guesses_and_hints: "+string(global.game_score_guesses_and_hints))
	
	//if global.game_score_guesses_and_hints <= 0 { //too many guesses or hints, make sure no time bonus either
	//	global.game_score_time_bonus = 0
	//}
	
	
	global.game_score_total = global.game_score_guesses_and_hints + global.game_score_time_bonus
	show_debug_message("global.game_score_total: "+string(global.game_score_total))

}