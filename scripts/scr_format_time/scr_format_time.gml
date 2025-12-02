/// @description scr_format_time(timetoformat,formatwithmilli)
/// @param timetoformat
/// @param formatwithmilli
function scr_format_time(timetoformat, formatwithmilli) {
//if (live_call(argument0,argument1)) return live_result;

	var v_timetoformat = timetoformat
	var v_formatwithmilli = formatwithmilli

	var v_time_hours = 0
	if v_timetoformat >= 216000 {
		v_time_hours = floor(((v_timetoformat/60)/60)/60)
	}
	var v_time_minutes = 0
	if v_timetoformat >= 3600 {
		v_time_minutes = floor((v_timetoformat/60)/60)-(v_time_hours*60)
	}
	var v_time_seconds = (v_timetoformat div 60)-(v_time_minutes*60)-(v_time_hours*60*60)

	if v_formatwithmilli = 1 {
		var v_time_milliseconds = floor(((v_timetoformat / 60) * 1000)-(v_time_seconds*1000)-(v_time_minutes*60*1000)-(v_time_hours*60*60*1000))
	}

	if string_length(string(v_time_seconds)) = 1 {
		v_time_seconds = "0"+string(v_time_seconds) //string_insert("0", string(v_time_seconds), 0)
	}
	
	if v_time_hours > 0 {
		if string_length(string(v_time_minutes)) = 1 {
			v_time_minutes = "0"+string(v_time_minutes) //string_insert("0", string(v_time_minutes), 0)
		}
	}


	if v_formatwithmilli = 0 {
		
		var v_time_formatted = v_timetoformat //
		if v_time_hours > 0 { //v_timetoformat > 216000 {
			v_time_formatted = string(v_time_hours)+":"+string(v_time_minutes)+":"+string(v_time_seconds)
		} else {
			v_time_formatted = string(v_time_minutes)+":"+string(v_time_seconds)
		}
		
		
		//v_time_formatted = string(v_time_minutes)+":"+string(v_time_seconds)
		
		//v_time_formatted = v_timetoformat

		//v_time_formatted = string(v_time_minutes)+":"+string(v_time_seconds)
		return (v_time_formatted);

	} else if v_formatwithmilli = 1 {
	
		var _str_l_ms = string_length(string(v_time_milliseconds))
		if _str_l_ms = 2 {
			v_time_milliseconds = "0"+string(v_time_milliseconds) //string_insert("0", string(v_time_milliseconds), 0)
		} else if _str_l_ms = 1 {
			v_time_milliseconds = "00"+string(v_time_milliseconds) //string_insert("00", string(v_time_milliseconds), 0)
		}
		
		var v_time_formatted_milli = v_timetoformat //
		if v_time_hours > 0 { //v_timetoformat > 216000 {
			v_time_formatted_milli = string(v_time_hours)+":"+string(v_time_minutes)+":"+string(v_time_seconds)+"."+string(v_time_milliseconds)
		} else {
			v_time_formatted_milli = string(v_time_minutes)+":"+string(v_time_seconds)+"."+string(v_time_milliseconds)
		}
	
		return (v_time_formatted_milli);

	}





}

