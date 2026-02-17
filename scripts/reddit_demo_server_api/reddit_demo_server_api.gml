
/// @ignore
function api_get_http_manager() {
	with (obj_http_manager) return self;
	return instance_create_depth(0, 0, 0, obj_http_manager);
}

/// @ignore
function api_register_request(_req, _callback) {
	var _manager = api_get_http_manager();
	_manager.register(_req, _callback);
}

/// @desc This function allows you to save the state for the current user.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to save state to
/// @param {Any} _data The data you want to save.
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_save_state(_postId, _data, _callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/state?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");
    ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");

	// Build request body
    var _body = {};
    //if (is_real(_level)) _body.level = _level;
    if (is_struct(_data)) _body.data = _data;
	 
	 show_debug_message("api_save_state data: "+string(_data))
	
	// Make request
    var _json = json_stringify(_body);
    var _req = http_request(_url, "POST", _headers, _json);
	
	// Free memory
    ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);

	return _req; // keep to match in Async HTTP event
}

/// @desc This function allows you to load the state for the current user.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to load state from
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_load_state(_postId,_callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/state?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	
	// Make request
    var _req = http_request(_url, "GET", _headers, "");
    
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
    return _req;
}

//profile

/// @desc This function allows you to save the user for the current user.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Any} _data The data you want to save.
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_save_profile(_profileData, _callback) {
		
	// Build request url
    var _url = reddit_get_base_url() + "/api/profile";

	// Build request headers
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");
    ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");

	// Build request body
    var _body = {};
	 //if (is_real(_stat_1)) _body.stat_1 = _stat_1;
	 //if (is_real(_stat_2)) _body.stat_2 = _stat_2;
    if (is_struct(_profileData)) _body.profileData = _profileData;
	
	// Make request
    var _json = json_stringify(_body);
	 
	 show_debug_message("api_save_profile json")
	 show_debug_message(_json)
	 
    var _req = http_request(_url, "POST", _headers, _json);
	
	// Free memory
    ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
	//scr_profile_update_stats()

	return _req; // keep to match in Async HTTP event
}

/// @desc This function allows you to load the user for the current user.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_load_profile(_callback) {
		
	// Build request url
    var _url = reddit_get_base_url() + "/api/profile";

	// Build request headers
    var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	
	// Make request
    var _req = http_request(_url, "GET", _headers, "");
    
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
	show_debug_message("api_load_profile called")
	
   return _req;
}

//end of user

/// @desc This function allows you to submit a new user highscore.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to save score to
/// @param {Real} _score The score to submit.
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_submit_score(_postId, _score, _callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/score?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");

	// Build request body
    var _body = {};
	if (is_real(_score)) _body.score = _score;

	// Make request
    var _json = json_stringify(_body);
    var _req = http_request(_url, "POST", _headers, _json);
	
	// Free memory
    ds_map_destroy(_headers);

	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);

	return _req;
}

/// @desc This function allows you to get the X top scores of the leaderboard.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to load lb from
/// @param {Real} _limit The limit number of elements to query (ie.: the top 10, for example)
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_get_leaderboard(_postId, _limit, _callback) {
	
	if _postId = "-9999" {_postId = ""}
		
	// Build request url
    if (!is_real(_limit)) _limit = 10;
	var _url = reddit_get_base_url() + "/api/leaderboard?limit=" + string(_limit)+"&postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
		
	// Make request
    var _req = http_request(_url, "GET", _headers, "");
	
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
    return _req;
}



/// @desc This function allows you to load the current post's data
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to load data from
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_load_postData(_postId,_callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/load-post-data?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	
	// Make request
    var _req = http_request(_url, "GET", _headers, "");
    
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
    return _req;
}

/// @desc This function allows you to save the state for the current user.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to update data to
/// @param {Any} _data The data you want to save.
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_update_postData(_postId, _data, _callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/update-post-data?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");
    ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");

	// Build request body
    var _body = {};
    if (is_struct(_data)) _body.data = _data;
	
	// Make request
    var _json = json_stringify(_body);
    var _req = http_request(_url, "POST", _headers, _json);
	
	// Free memory
    ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);

	return _req; // keep to match in Async HTTP event
}


/// @desc This function allows you to load the current post's data
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _postId The post to load data from
/// @param {Function} _callback The callback that you want to be executed upon task completion.
function api_get_surrounding_daily_ids(_postId,_callback) {
	
	if _postId = "-9999" {_postId = ""}
	
	// Build request url
    var _url = reddit_get_base_url() + "/api/get-surrounding-daily-ids?postId="+string(_postId);

	// Build request headers
    var _headers = ds_map_create();
	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");
	
	// Make request
    var _req = http_request(_url, "GET", _headers, "");
    
	// Free memory
	ds_map_destroy(_headers);
	
	// Register request callback
	if (is_callable(_callback)) api_register_request(_req, _callback);
	
    return _req;
}


/// @desc This function allows you to submit a new user highscore.
/// For more details check the server demo implementation under the output folder:
/// <output>/<project_name>/src/server/index.ts
/// @param {Real} _score The score to submit.
/// @param {Function} _callback The callback that you want to be executed upon task completion.
//function api_toggle_class(_html_target_element_id, _html_class, _callback) {
	
//	// Build request url
//    var _url = reddit_get_base_url() + "/api/toggleclass";

//	// Build request headers
//    var _headers = ds_map_create();
//    ds_map_add(_headers, "Content-Type", "application/json");
//	ds_map_add(_headers, "Authorization", $"Bearer {reddit_get_token()}");

//	// Build request body
//    var _body = {};
//	//if (is_real(_score)) _body.score = _score;
//	//if (is_struct(_data)) _body.data = _data;
//	if (is_string(_html_target_element_id)) _body.html_target_element_id = _html_target_element_id;
//	if (is_string(_html_class)) _body.html_class = _html_class;

//	// Make request
//    var _json = json_stringify(_body);
//    var _req = http_request(_url, "POST", _headers, _json);
	
//	// Free memory
//    ds_map_destroy(_headers);

//	// Register request callback
//	if (is_callable(_callback)) api_register_request(_req, _callback);

//	return _req;
//}