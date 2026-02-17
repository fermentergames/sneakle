//submit score happened 1 sec ago, now try to load lb

if postId != -1 && postId != "-9999" {
	api_get_leaderboard(postId, 15, function(_status, _ok, _result) {
		try {
			var _state = json_parse(_result);
			show_debug_message("LEADERBOARD GOT!")
			show_debug_message(json_stringify(_state))
							
			lb_json = _state
			lb_json_stringified = json_stringify(_state,true)
		
			lb_total_players = real(lb_json.totalPlayers)
			lb_your_rank = real(lb_json.me.rank)
			lb_your_percentile = ceil((1-(lb_your_rank/clamp(lb_total_players,1,99999999)))*100)
			if lb_your_rank = 1 {
				lb_your_percentile = 100
			}
		
			show_debug_message(lb_json.top)
		
			//show_debug_message(lb_json.top[0])
		
			show_debug_message(array_length(lb_json.top))
		
		
			for (var i = 1; i <= array_length(lb_json.top); ++i) {
			   lb_entry[i,1] = string(lb_json.top[(i-1)].rank) //rank
				lb_entry[i,2] = string(lb_json.top[(i-1)].username) //name
				lb_entry[i,3] = string(lb_json.top[(i-1)].score) //score
			}
		
			show_debug_message(lb_entry)
		
						
		}
		catch (_ex) {
			show_debug_message("LEADERBOARD GET FAILED!")
			alarm[1] = 120; //try again
		}
	
	});

} else {
	show_debug_message("SKIP LEADERBOARD GET, postId not set")
}
