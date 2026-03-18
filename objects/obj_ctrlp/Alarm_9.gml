if global.is_reddit = 1 {

	api_load_profile(function(_status, _ok, _result, _payload) {
		try {
				
			load_profile_attempts += 1
				
			show_debug_message("load_profile_attempts=")
			show_debug_message(load_profile_attempts)
				
			var _profile = json_parse(_result);
			
			show_debug_message("api_load_profile got")
			show_debug_message(_profile)
			
			username = _profile.username;
			
			stat_d_total_started = _profile.stat_d_total_started;
			stat_d_total_finished = _profile.stat_d_total_finished;
			stat_d_total_gaveup = _profile.stat_d_total_gaveup;
			stat_d_total_score = _profile.stat_d_total_score;
			stat_d_total_time = _profile.stat_d_total_time;
			stat_d_total_guesses = _profile.stat_d_total_guesses;
			stat_d_total_hints = _profile.stat_d_total_hints;

			stat_u_total_started = _profile.stat_u_total_started;
			stat_u_total_finished = _profile.stat_u_total_finished;
			stat_u_total_gaveup = _profile.stat_u_total_gaveup;
			stat_u_total_score = _profile.stat_u_total_score;
			stat_u_total_time = _profile.stat_u_total_time;
			stat_u_total_guesses = _profile.stat_u_total_guesses;
			stat_u_total_hints = _profile.stat_u_total_hints;
			
			created_total = _profile.created_total;
			created_ids = _profile.created_ids;

			option_darkmode = _profile.option_darkmode;
			option_sfx = _profile.option_sfx;
			option_show_timer = _profile.option_show_timer;
				
			profile_joined = _profile.profile_joined;

			scr_profile_update_stats()
			
			load_profile_complete = 1
				
			if real(stat_d_total_started) + real(stat_u_total_started) <= 0 {
				global.show_howto = 1 //temp tutorial	
			}
		}
		catch (_ex) { //if no state data loaded, save the default values?
			
				
			if load_profile_attempts < 5 {
				alarm[9] = 5
				show_debug_message("api_load_profile initial failed, try again")
			} else {
				show_debug_message("api_load_profile failed 5 times, set default stats")
			
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
					stat_u_total_hints,
					created_total,
					created_ids,
					option_darkmode,
					option_sfx,
					option_show_timer,
					profile_joined
				}, function(_status, _ok, _result) {
					//alarm[4] = 60;
				});
				
				//if real(stat_d_total_started) + real(stat_u_total_started) <= 0 {
					global.show_howto = 1 //temp tutorial	
				//}	
			}
				
		}
	});

}

