///
function scr_grid_has_banned_words() {
	if (live_call()) return live_result;

	if !variable_global_exists("dictionary_banned") {
		return 0;
	}

	var _scan_line_for_banned = function(_line) {
		var _len = string_length(_line);
		if _len < 2 {
			return false;
		}

		for (var _start = 1; _start <= _len; ++_start) {
			for (var _slen = 2; _slen <= (_len - _start + 1); ++_slen) {
				if global.dictionary_banned.check(string_lower(string_copy(_line, _start, _slen))) {
					return true;
				}
			}
		}

		return false;
	}

	var _n = global.game_grid_size;
	var _grid_letters = array_create(global.game_grid_size_sqr + 1, "");

	for (var _i = 1; _i <= global.game_grid_size_sqr; ++_i) {
		var _tile = global.tile_letter[_i];
		if instance_exists(_tile) && _tile.am_set >= 1 {
			var _targ = _tile.targ_id;
			if instance_exists(_targ) && _targ != -1 {
				_grid_letters[_targ.tile_id] = string_lower(_tile.my_letter_str);
			}
		}
	}

	for (var _row = 0; _row < _n; ++_row) {
		var _row_str = "";
		for (var _col = 0; _col < _n; ++_col) {
			_row_str += _grid_letters[1 + (_row * _n) + _col];
		}

		//var _row_rev = "";
		//for (var _ri = string_length(_row_str); _ri >= 1; --_ri) {
		//    _row_rev += string_char_at(_row_str, _ri);
		//}

		if _scan_line_for_banned(_row_str) /* || _scan_line_for_banned(_row_rev) */ {
			return 1;
		}
	}

	for (var _col = 0; _col < _n; ++_col) {
		var _col_str = "";
		for (var _row = 0; _row < _n; ++_row) {
			_col_str += _grid_letters[1 + (_row * _n) + _col];
		}

		//var _col_rev = "";
		//for (var _ci = string_length(_col_str); _ci >= 1; --_ci) {
		//    _col_rev += string_char_at(_col_str, _ci);
		//}

		if _scan_line_for_banned(_col_str) /* || _scan_line_for_banned(_col_rev) */ {
			return 1;
		}
	}

	return 0;
}
