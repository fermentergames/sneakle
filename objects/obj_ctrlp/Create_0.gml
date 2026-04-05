if (live_call()) return live_result;

if (instance_number(obj_ctrlp) > 1) {
	var first = instance_find(obj_ctrlp, 0);
	if (id != first) { instance_destroy(); exit; }
}

show_debug_message("obj_ctrlp created!")

global.dictionary = new CheckWordDictionary(working_directory + "dictionaries/full/full.txt");
global.dictionary_simple = new CheckWordDictionary(working_directory + "dictionaries/simple/full.txt");

global.dictionary_generate = new PickWordDictionary(working_directory + "dictionaries/simpler_MIT_by_length/5.txt");


global.game_timer_meta = 0

#macro COL_RED_EXED make_color_hsv(245,220,20)
#macro COL_RED_EXED_BORD make_color_hsv(250,255,205)
#macro COL_CLUED_GREEN make_color_hsv(100,255,210)

#macro LEVEL_STATUS_NotStarted 0
#macro LEVEL_STATUS_Started 1
#macro LEVEL_STATUS_GaveUp 2
#macro LEVEL_STATUS_Complete 3
#macro LEVEL_STATUS_IsAuthor 4

#macro STATS_UNLIMITED 0
#macro STATS_DAILY 1
#macro STATS_COMMUNITY 2


//archive browser stuff
global.browser_cursor = 0;
global.browser_page = 0;
global.browser_limit = 8;
global.browser_tag = "daily"; // or "" for all

global.browser_puzzles = []; // array of structs
global.browser_loading = false;
global.browser_hasMore = true;
global.browser_total = 0;
global.browser_pending_last = false;

//


global.light_mode = 0
global.show_debug = 0

global.game_loading = 0

clear_stats_confirm = 0
just_submitted_score = 0

load_profile_complete = 0
load_profile_attempts = 0
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
	
	lb_entry_near[i,1] = "-"//rank
	lb_entry_near[i,2] = "-"//name
	lb_entry_near[i,3] = "-"//score
}

lbmenu_which = 1
lbmenu_which_fd = 1
lbmenu_which_variant = 1
lbmenu_variant1_fd = 1
lbmenu_variant2_fd = 0
lb_switch_time_max = 300
lb_switch_time = lb_switch_time_max
lb_variant_hovered = 0
lb_variant_hovered_fd = 0

postData = undefined
postData_str = "postData not found"
postData_levelName = ""
postData_levelTag = ""
postData_levelID = -1
postData_levelDate = -1
postData_levelDate_formatted = -1
postData_levelCreator = ""
postData_gameData = ""
postData_totalPlayers = 1
postData_totalPlayersCompleted = 0
postData_totalGuesses = 0
postData_totalTime = 0
postData_totalScore = 0
postData_nonStandard = 0

puzzle_is_daily = 0
puzzle_is_special = 0
puzzle_is_community = 0
puzzle_is_unlimited = 0

surrounding_res = -1
surrounding_res_str = ""
daily_prev_postId = "-9999"
daily_next_postId = "-9999"
daily_today_postId = "-9999"

loading_postdata_stage = 0
loading_postdata_info = ""


get_query()//check for "launch into create" first


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
	
	stat_c_total_started		= "0"
	stat_c_total_finished	= "0"
	stat_c_total_gaveup		= "0"
	stat_c_total_score		= "0"
	stat_c_total_time			= "0"
	stat_c_total_guesses		= "0"
	stat_c_total_hints		= "0"

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
	
	profile_joined = "0"


	stat_d_total_finished_perc = "0"
	stat_d_total_score_avg = "0"
	stat_d_total_time_avg =	"0"
	stat_d_total_guesses_avg = "0"
	
	stat_c_total_finished_perc = "0"
	stat_c_total_score_avg = "0"
	stat_c_total_time_avg =	"0"
	stat_c_total_guesses_avg = "0"

	stat_u_total_finished_perc = "0%"
	stat_u_total_score_avg = "0"
	stat_u_total_time_avg =	"0"
	stat_u_total_guesses_avg = "0"


	//


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
				
				stat_c_total_started = _profile.stat_c_total_started;
				stat_c_total_finished = _profile.stat_c_total_finished;
				stat_c_total_gaveup = _profile.stat_c_total_gaveup;
				stat_c_total_score = _profile.stat_c_total_score;
				stat_c_total_time = _profile.stat_c_total_time;
				stat_c_total_guesses = _profile.stat_c_total_guesses;
				stat_c_total_hints = _profile.stat_c_total_hints;

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
				
				if real(stat_d_total_started) + real(stat_u_total_started) + real(stat_c_total_started) <= 0 {
					global.show_howto = 1 //temp tutorial	
				}
			}
			catch (_ex) { //if no state data loaded, save the default values?
			
				show_debug_message("api_load_profile initial failed, try again")
				alarm[9] = 1
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


