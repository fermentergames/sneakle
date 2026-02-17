/// @description Don't forget to place this object in the first room!
// this is a simple safeguard against making multiple obj_gmlive instances
if (instance_number(obj_gmlive) > 1) {
	var first = instance_find(obj_gmlive, 0);
	if (id != first) { instance_destroy(); exit; }
}

// flip this value to 0 to disable GMLive!
#macro live_enabled 1//1 //0

if (asset_get_index("live_init") == -1) show_error("live_init is missing!\nEither GMLive is not imported in the project, or the 'GMLive' script got corrupted (try re-importing)\nIf you don't have GMLive, you can safely remove obj_gmlive and any remaining live_* function calls.\n\n", 1);

// change the IP/port here if gmlive-server isn't running on the same device as the game
// (e.g. when running on mobile platforms):
live_init(1, "http://localhost:5100", "");

// if you need to add any overrides because of 


live_blank_object = obj_blank;
live_blank_room = rm_blank;

room_set_live(Room1, true);

var _register = function(_type, _get_name) {
	var _ids = asset_get_ids(_type);
	for (var i = 0, n = array_length(_ids); i < n; i++) {
		var _id = _ids[i];
		var _name = _get_name(_id);
		live_constant_add(_name, _id);
	}
}
_register(asset_sprite, sprite_get_name);
_register(asset_sound, audio_get_name);
_register(asset_object, object_get_name);
_register(asset_room, room_get_name);
