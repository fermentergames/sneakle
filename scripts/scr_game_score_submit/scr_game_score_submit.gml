///
function scr_game_score_submit(){
if (live_call()) return live_result;
	with (obj_ctrlp) {
		
		if already_finished <= 0 {

			show_debug_message("scr_game_score_submit happening")
		
			score_guesses = obj_ctrl.guesses_count
			score_hints = global.game_hints_used
			score_time = global.game_timer
			score_combined = global.game_score_total
			
			
			
			level_status = LEVEL_STATUS_Complete
			if global.gave_up >= 1 {
				level_status = LEVEL_STATUS_GaveUp	
			}
		
			postData_totalPlayers = string(real(postData_totalPlayers)+1)
			if global.gave_up <= 0 {
				postData_totalPlayersCompleted = string(real(postData_totalPlayersCompleted)+1)
				postData_totalGuesses = string(real(postData_totalGuesses)+obj_ctrl.guesses_count)
				postData_totalTime = string(real(postData_totalTime)+global.game_timer)
				postData_totalScore = string(real(postData_totalScore)+global.game_score_total)
			}
		
			//send these vars instead, so that json names match expected
			var totalPlayers = postData_totalPlayers
			var totalPlayersCompleted = postData_totalPlayersCompleted
			var totalGuesses = postData_totalGuesses
			var totalTime = postData_totalTime
			var totalScore = postData_totalScore
			
			
			
			if puzzle_is_daily = 1 {
				//stat_d_total_started = string(real(stat_d_total_started)+1)
				if global.gave_up <= 0 {
					stat_d_total_finished = string(real(stat_d_total_finished)+1)
				} else {
					stat_d_total_gaveup = string(real(stat_d_total_gaveup)+1)
				}
				stat_d_total_score = string(real(stat_d_total_score)+global.game_score_total)
				stat_d_total_time = string(real(stat_d_total_time)+global.game_timer)
				stat_d_total_guesses = string(real(stat_d_total_guesses)+obj_ctrl.guesses_count)
				stat_d_total_hints = string(real(stat_d_total_hints)+global.game_hints_used)
			} else { //non daily
				//stat_u_total_started = string(real(stat_u_total_started)+1)
				if global.gave_up <= 0 {
					stat_u_total_finished = string(real(stat_u_total_finished)+1)
				} else {
					stat_u_total_gaveup = string(real(stat_u_total_gaveup)+1)
				}
				stat_u_total_score = string(real(stat_u_total_score)+global.game_score_total)
				stat_u_total_time = string(real(stat_u_total_time)+global.game_timer)
				stat_u_total_guesses = string(real(stat_u_total_guesses)+obj_ctrl.guesses_count)
				stat_u_total_hints = string(real(stat_u_total_hints)+global.game_hints_used)
			}
			
			scr_profile_update_stats()
			

			if global.is_reddit = 1 {
				
				if postId != -1 && postId != "-9999" {

					api_save_state(postId, { score_guesses, score_hints, score_time, score_combined, level_status }, function(_status, _ok, _result) {
						alarm[0] = 60;
					});
					
					api_submit_score(postId,score_combined,function(_status, _ok, _result) {
						alarm[1] = 30; //will fetch lb after
					});
			
					api_update_postData(postId, { totalPlayers, totalPlayersCompleted, totalGuesses, totalTime, totalScore }, function(_status, _ok, _result) {
						alarm[0] = 60;
					});
				
				}
				
				
				if puzzle_is_daily = 1 && postId != -1 && postId != "-9999" {
					api_save_profile({
						stat_d_total_started,
						stat_d_total_finished,
						stat_d_total_gaveup,
						stat_d_total_score,
						stat_d_total_time,
						stat_d_total_guesses,
						stat_d_total_hints,
					}, function(_status, _ok, _result) {
						//alarm[4] = 60;
					});
				} else {
					api_save_profile({
						stat_u_total_started,
						stat_u_total_finished,
						stat_u_total_gaveup,
						stat_u_total_score,
						stat_u_total_time,
						stat_u_total_guesses,
						stat_u_total_hints,
					}, function(_status, _ok, _result) {
						//alarm[4] = 60;
					});
				}
					
			}
		
		} else {
			show_debug_message("scr_game_score_submit skipping because already finished")
			
			alarm[1] = 30; //will fetch lb after
			
		}

	}
}