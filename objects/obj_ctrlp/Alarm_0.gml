if (1= 0 ) { //prev_points != points) {
	prev_points = points;
	api_save_state(postId, { points }, function(_status, _ok, _result) {
		alarm[0] = 60;
	});
}
//else alarm[0] = 60;

