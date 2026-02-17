///
function safe_json_get(_struct, _key, _default) {
	if (is_struct(_struct) && variable_struct_exists(_struct, _key)) {
		return _struct[@ _key];
	} else {
		show_debug_message("safe_json_get failed to get key "+string(key))
		return _default;
	}
}