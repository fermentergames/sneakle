///

/// @function scr_format_levelDate(_iso, _includeWeekday)
/// @param _iso           ISO date string (e.g. "2026-02-12T06:21:59.032Z")
/// @param _includeWeekday  true/false to include weekday
function scr_format_levelDate(_isoDate, _includeWeekday)
{
	
	//show_debug_message("ISO DATE: " + string(_isoDate));
   if (is_undefined(_isoDate)) return "Invalid Date";

    var parts = string_split(_isoDate, "T");
    if (array_length(parts) < 2) return "Invalid Date";

    var datePart = parts[0];

    var datePieces = string_split(datePart, "-");
    if (array_length(datePieces) != 3) return "Invalid Date";

    if (!string_digits(datePieces[0]) ||
        !string_digits(datePieces[1]) ||
        !string_digits(datePieces[2]))
    {
        return "Invalid Date";
    }

    var year  = real(datePieces[0]);
    var month = real(datePieces[1]);
    var day   = real(datePieces[2]);

    var dt = date_create_datetime(year, month, day, 0, 0, 0);

    var result = string(month) + "/" + string(day) + "/" + string(year);

    if (_includeWeekday >= 1)
    {
	      var weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
	      var weekdayIndex = date_get_weekday(dt);
		  
			var weekday_str = "-" //weekdays[weekdayIndex - 1]
		  
			if weekdayIndex >= 0 {  
				weekday_str = weekdays[weekdayIndex]
			}

			if _includeWeekday = 2 {
				result = weekday_str
			} else {
				result = weekday_str + " " + result;
			}
		  
    }

    return result;
}

//function scr_format_levelDate(_postData_levelDate) {
//	with (obj_ctrlp) {

//		//_postData_levelDate
//		postData_levelDate_formatted

//	}
//}