function scr_browser_load_next_page() {

    // Already loading or no more data from server
    if (global.browser_loading) return;
    if (!global.browser_hasMore) return;

    global.browser_loading = true;

    api_list_levels(
        global.browser_cursor,
        global.browser_limit,
        global.browser_tag,
        function(_status, _ok, _result) {

            global.browser_loading = false;

            if (!_ok) {
                show_debug_message("LIST LEVELS FAILED");
                return;
            }

            try {
               var data = json_parse(_result);

               show_debug_message("LIST LEVELS OK");
               show_debug_message(json_stringify(data));

               var puzzles = data.puzzles;

               // Append new results to existing array
               for (var i = 0; i < array_length(puzzles); i++) {
                  array_push(global.browser_puzzles, puzzles[i]);
						
						
						//var _ldate = scr_format_levelDate(global.browser_puzzles[i].levelDate,false)
						//_ldate = string_copy(_ldate,0,string_length(_ldate)-5)
						//global.browser_puzzles[i].date_mmdd = _ldate
						
						//var _ldaywk = scr_format_levelDate(global.browser_puzzles[i].levelDate,2)
						//global.browser_puzzles[i].date_wkday = _ldaywk
               }

               // Update API pagination cursor
               global.browser_cursor = data.nextCursor;
               global.browser_hasMore = data.hasMore;

               // if user is on last page, move to next page automatically
               var total_pages = ceil(array_length(global.browser_puzzles) / global.browser_limit);
               if (global.browser_page >= total_pages - 1) {
                  global.browser_page = total_pages - 1;
               }
					 
					// After appending puzzles...
					var total = array_length(global.browser_puzzles);
					var total_pages = ceil(total / global.browser_limit);

					//
					if (global.browser_pending_last) {

					   if (global.browser_hasMore) {
					      // Still not fully loaded, loop again
					      scr_browser_load_next_page();
					      return;
					   }

					   // Done loading everything → go to last page
					   var total_pages = ceil(array_length(global.browser_puzzles) / global.browser_limit);
					   global.browser_page = max(0, total_pages - 1);

					   global.browser_pending_last = false;
						
					} else {
					
						// If user was trying to go forward, now allow it
						if (global.browser_page < total_pages - 1) {
						   global.browser_page += 1;
						}
					
					}

            } catch (_ex) {
                show_debug_message("PARSE FAILED");
            }
        }
    );
}