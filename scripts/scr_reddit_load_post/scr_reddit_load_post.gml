///
function scr_reddit_reset_post() {
with (obj_ctrlp) {
	
	show_debug_message("scr_reddit_reset_post")
	
	global.game_loading = 0
	global.loadBoard = ""
	
	load_post_data_complete = 0
	load_state_complete = 0
	level = 0; //unused
	points = 0; //unused
	postId = "-9999"
	//postId_orig = postId

	score_guesses = 0
	score_hints = 0
	score_time = 0
	score_combined = 0
	level_status = LEVEL_STATUS_NotStarted

	already_finished = 0

	prev_points = 0;

	lb_json = undefined
	lb_json_stringified = "not found"

	lb_total_players = -1
	lb_your_rank = -1
	lb_your_percentile = -1

	for (var i = 1; i <= 15; ++i) {
	   lb_entry[i,1] = "-"//rank
		lb_entry[i,2] = "-"//name
		lb_entry[i,3] = "-"//score
	}

	postData = undefined
	postData_str = "postData not found"
	postData_levelName = ""
	postData_levelTag = ""
	postData_levelID = -1
	postData_dailyID = -1
	postData_gameData = ""
	postData_totalPlayers = 1
	postData_totalPlayersCompleted = 0
	postData_totalGuesses = 0
	postData_totalTime = 0
	postData_totalScore = 0

	puzzle_is_daily = 0
	puzzle_is_special = 0
	puzzle_is_community = 0
	puzzle_is_unlimited = 0

	surrounding_res = -1
	surrounding_res_str = ""
	//daily_prev_postId = "-9999" //don't reset these, needed during switch
	//daily_next_postId = "-9999" //don't reset these, needed during switch
	
}
	
}

////////////

function scr_reddit_load_post(_postIdToLoad="-9999") {

with (obj_ctrlp) {
	
	loading_postdata_stage = 1
	postId = string(_postIdToLoad)
	

	if global.is_reddit = 1 {
	
		global.game_loading = 1
		loading_postdata_stage = 2

		api_load_postData(postId, function(_status, _ok, _result) {
			try {
				
				loading_postdata_info = _result
				loading_postdata_stage = 2.5
				
				var _postData = json_parse(_result);
				show_debug_message("postData GOT!")
				
				loading_postdata_stage = 3
			
							
				postData = _postData
				postData_str = json_stringify(_postData,true)
			
				show_debug_message(postData_str)
		
				loading_postdata_stage = 4
		
				postData_levelName = _postData.levelName;
				show_debug_message(postData_levelName)
				postData_levelTag = _postData.levelTag;
				show_debug_message(postData_levelTag)
				postData_levelID = _postData.levelID;
				show_debug_message(postData_levelID)
				postData_dailyID = _postData.dailyID;
				show_debug_message(postData_dailyID)
				postData_gameData = _postData.gameData;
				show_debug_message(postData_gameData)
				postData_totalPlayers = _postData.totalPlayers;
				show_debug_message(postData_totalPlayers)
				postData_totalPlayersCompleted = _postData.totalPlayersCompleted;
				show_debug_message(postData_totalPlayersCompleted)
				postData_totalGuesses = _postData.totalGuesses;
				show_debug_message(postData_totalGuesses)
				postData_totalTime = _postData.totalTime;
				show_debug_message(postData_totalTime)
				postData_totalScore = _postData.totalScore;
				show_debug_message(postData_totalScore)
				
				loading_postdata_stage = 5
			
				postId = _postData.postId;
				
				if postId_orig = "-9999" { //only happens once
					postId_orig = postId;
				}
				show_debug_message("postId = "+string(postId))
			
				//reset
				puzzle_is_daily = 0
				puzzle_is_special = 0
				puzzle_is_community = 0
				puzzle_is_unlimited = 0
			
				if postData_levelTag = "daily" {
					puzzle_is_daily = 1
				
					alarm[6] = 1 //will try to get prev+next postIds
				
				} else if postData_levelTag = "special" {
					puzzle_is_special = 1
				} else if postData_levelTag = "community" {
					puzzle_is_community = 1
				}

				//show_debug_message("postData_levelName = "+string(postData_levelName))
				//show_debug_message("postData_levelTag = "+string(postData_levelTag))
				//show_debug_message("postData_levelID = "+string(postData_levelID))
				//show_debug_message("postData_gameData = "+string(postData_gameData))
				
				loading_postdata_stage = 6
			
				load_post_data_complete = 1
			
				show_debug_message("load_post_data_complete")
			
		
			}
			catch (_ex) {
				
				loading_postdata_stage *= -1
				show_debug_message("postData FAILED!")
				global.game_loading = 0
				alarm[3] = 60;
			}
			
		});

		//

		api_load_state(postId, function(_status, _ok, _result, _payload) {
			try {
			
				show_debug_message("trying api_load_state")
			
				var _state = json_parse(_result);

				var _state_str = json_stringify(_state,true)
				show_debug_message(_state_str)
				
				//username = _state.username;
				//level = _state.level;
				score_guesses = _state.data.score_guesses;
				score_hints = _state.data.score_hints;
				score_time = _state.data.score_time;
				score_combined = _state.data.score_combined;
				level_status = _state.data.level_status;
			
				show_debug_message("api_load_state loaded most stuff")
			
				if level_status >= LEVEL_STATUS_GaveUp {
					already_finished = 1
					show_debug_message("level_status >= LEVEL_STATUS_GaveUp, set already_finished")
				
					//scr_board_init will trigger game to autocomplete
				}
			
				load_state_complete = 1
				show_debug_message("load_state_complete")
			}
			catch (_ex) { //if no state data loaded, save the default values?
				
				show_debug_message("api_load_state failed on postId:"+string(postId)+", save over with current values")
				show_debug_message("level_status: "+string(level_status))
				api_save_state(postId, { score_guesses, score_hints, score_time, score_combined, level_status }, undefined);
				load_state_complete = 1
				alarm[0] = 60;
			}
			
		});


		//if both postData and state loaded, get the board data and init the board
		if global.game_loading != 0 {
			
			show_debug_message("load_post_data_complete = "+string(load_post_data_complete))
			show_debug_message("load_state_complete = "+string(load_state_complete))
			
			if load_post_data_complete = 1 && load_state_complete = 1 {
				
				global.loadBoard = ""
				global.game_phase = 0
				scr_board_reset_defs()
	
				show_debug_message("trying to load board via get_query_reddit() with postData_gameData")
				get_query_reddit()
				global.game_loading = 0	
		
	
			} else {
				
				show_debug_message("load_post_data_complete != 1 || load_state_complete != 1")
				
				if global.loadBoard = "" {
					alarm[5] = 10	
				}
			}
		} else {
			show_debug_message("game_loading = 0, don't load board?")
		}

	}
	
}
}