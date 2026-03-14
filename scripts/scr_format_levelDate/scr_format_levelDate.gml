///

/// @function scr_format_levelDate(_iso, _includeWeekday)
/// @param _iso           ISO date string (e.g. "2026-02-12T06:21:59.032Z")
/// @param _includeWeekday  true/false to include weekday
function scr_format_levelDate(_isoDate, _includeWeekday)
{
	
    var datePart = string_copy(_isoDate, 1, 10); // "2026-02-12"

    var year  = real(string_copy(datePart, 1, 4));
    var month = real(string_copy(datePart, 6, 2));
    var day   = real(string_copy(datePart, 9, 2));

    var dt = date_create_datetime(year, month, day, 0, 0, 0);

    var result = string(month) + "/" + string(day) + "/" + string(year);

    if (_includeWeekday)
    {
        var weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
        var weekdayIndex = date_get_weekday(dt); // 1-7
        result = weekdays[weekdayIndex-1] + " " + result;
    }

    return result;
}

//function scr_format_levelDate(_postData_levelDate) {
//	with (obj_ctrlp) {

//		//_postData_levelDate
//		postData_levelDate_formatted

//	}
//}