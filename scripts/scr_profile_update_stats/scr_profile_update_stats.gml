///
function scr_profile_update_stats(){
	if (live_call()) return live_result;
	
	with (obj_ctrlp) {
		
		if stat_d_total_finished > stat_d_total_started {
			stat_d_total_finished = stat_d_total_started	
		}
		if stat_d_total_started < stat_d_total_finished {
			stat_d_total_started = stat_d_total_finished
		}
		
		if stat_d_total_finished > 0 && stat_d_total_started > 0 {
			
			stat_d_total_finished_perc = string(round(100*(real(stat_d_total_finished)/real(stat_d_total_started))))+"%"
			stat_d_total_score_avg = string(round(real(stat_d_total_score)/real(stat_d_total_finished)))
			stat_d_total_guesses_avg = string(round(real(stat_d_total_guesses)/real(stat_d_total_finished)))
			stat_d_total_time_avg =	round(real(stat_d_total_time)/real(stat_d_total_finished))
			stat_d_total_time_avg = string(scr_format_time(stat_d_total_time_avg,0))
		}
		
		
			
			
		if stat_u_total_finished > stat_u_total_started {
			stat_u_total_finished = stat_u_total_started	
		}
		if stat_u_total_started < stat_u_total_finished {
			stat_u_total_started = stat_u_total_finished
		}
		
		if stat_u_total_finished > 0 && stat_u_total_started > 0 {
			//show_debug_message(stat_u_total_finished)
			//show_debug_message(stat_u_total_started)
			
			
			stat_u_total_finished_perc = string(round(100*(real(stat_u_total_finished)/real(stat_u_total_started))))+"%"
			stat_u_total_score_avg = string(round(real(stat_u_total_score)/real(stat_u_total_finished)))
			stat_u_total_guesses_avg = string(round(real(stat_u_total_guesses)/real(stat_u_total_finished)))
			stat_u_total_time_avg =	round(real(stat_u_total_time)/real(stat_u_total_finished))
			stat_u_total_time_avg = string(scr_format_time(stat_u_total_time_avg,0))
		}
	
	}
	
}