//just update player total after leaderboard sync check

if postId != -1 && postId != "-9999" {
	
	var totalPlayers = postData_totalPlayers
	
	show_debug_message("updating postData_totalPlayers to match lb total")
	
	api_update_postData(postId, { totalPlayers }, function(_status, _ok, _result) {
		//alarm[0] = 60;
	});
}
					