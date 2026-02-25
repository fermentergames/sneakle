if (live_call()) return live_result;

if (instance_number(obj_ctrlp) > 1) {
	var first = instance_find(obj_ctrlp, 0);
	if (id != first) { instance_destroy(); exit; }
}

show_debug_message("obj_ctrlp created!")

global.dictionary = new CheckWordDictionary(working_directory + "dictionaries/full/full.txt");
global.dictionary_simple = new CheckWordDictionary(working_directory + "dictionaries/simple/full.txt");

global.dictionary_generate = new PickWordDictionary(working_directory + "dictionaries/simple_by_length/5.txt");

scr_letter_data_init()

global.light_mode = 0

#macro COL_RED_EXED make_color_hsv(245,220,20)
#macro COL_RED_EXED_BORD make_color_hsv(250,255,205)
#macro COL_CLUED_GREEN make_color_hsv(100,255,210)

#macro LEVEL_STATUS_NotStarted 0
#macro LEVEL_STATUS_Started 1
#macro LEVEL_STATUS_GaveUp 2
#macro LEVEL_STATUS_Complete 3


global.show_debug = 0

global.game_loading = 0

clear_stats_confirm = 0


load_profile_complete = 0
username = "";

load_post_data_complete = 0
load_state_complete = 0
level = 0; //unused
points = 0; //unused
postId = "-9999"
postId_orig = postId

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
daily_prev_postId = "-9999"
daily_next_postId = "-9999"

loading_postdata_stage = 0
loading_postdata_info = ""

scr_reddit_reset_post()


scr_reddit_load_post()




if 1=1 {//STATS

	stat_1 = 0
	stat_2 = 0
	stat_3 = 0
	stat_4 = 0

	//stat_d_total_failed: d.stat_d_total_failed ?? "0",

	stat_d_total_started		= "0"
	stat_d_total_finished	= "0"
	stat_d_total_gaveup		= "0"
	stat_d_total_score		= "0"
	stat_d_total_time			= "0"
	stat_d_total_guesses		= "0"
	stat_d_total_hints		= "0"

	stat_u_total_started		= "0"
	stat_u_total_finished	= "0"
	stat_u_total_gaveup		= "0"
	stat_u_total_score		= "0"
	stat_u_total_time			= "0"
	stat_u_total_guesses		= "0"
	stat_u_total_hints		= "0"

	created_total = "0"
	created_ids = "-1" //fill with puzzle id comma separated

	option_darkmode			= "1"
	option_sfx					= "1"
	option_show_timer			= "1"


	stat_d_total_finished_perc = "0"
	stat_d_total_score_avg = "0"
	stat_d_total_time_avg =	"0"
	stat_d_total_guesses_avg = "0"

	stat_u_total_finished_perc = "0%"
	stat_u_total_score_avg = "0"
	stat_u_total_time_avg =	"0"
	stat_u_total_guesses_avg = "0"


	//


	if global.is_reddit = 1 {

		api_load_profile(function(_status, _ok, _result, _payload) {
			try {
				var _profile = json_parse(_result);
			
				show_debug_message("api_load_profile got")
				show_debug_message(_profile)
			
				username = _profile.username;
				////level = _profile.level;
				//stat_1 = _profile.stat_1;
				//stat_2 = _profile.stat_2;
				//stat_3 = _profile.profileData.stat_3;
				//stat_4 = _profile.profileData.stat_4;
			
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

				scr_profile_update_stats()
			
				load_profile_complete = 1
			}
			catch (_ex) { //if no state data loaded, save the default values?
			
				show_debug_message("api_load_profile initial failed, set default stats")
			
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
					option_show_timer
				}, function(_status, _ok, _result) {
					//alarm[4] = 60;
				});
			}
			//alarm[4] = 60;
		});

	}

}


//html_target_element_id = "menu-modal"
//html_class = "active"

//if global.is_reddit = 1 {
				
//	//show_debug_message("api_toggle_class trying")
//	//api_toggle_class({ html_target_element_id, html_class }, function(_status, _ok, _result) {
//	//	show_debug_message("api_toggle_class complete?")
//	//	//alarm[4] = 60;			
//	//});	
//}


