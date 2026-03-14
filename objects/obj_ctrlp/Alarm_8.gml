//submit score happened 1 sec ago, now try to load lb

show_debug_message("LEADERBOARD COMMENT TRY!")

if postId != -1 && postId != "-9999" {
	api_leaderboard_comment(postId, function(_status, _ok, _result) {
		try {
			var _state = json_parse(_result);
			show_debug_message("LEADERBOARD COMMENT SUCCESS!")
			show_debug_message(json_stringify(_state))	
		}
		catch (_ex) {
			show_debug_message("LEADERBOARD COMMENT FAILED!")
			//alarm[1] = 120; //try again
		}
	
	});

} else {
	show_debug_message("SKIP LEADERBOARD COMMENT, postId not set")
}
