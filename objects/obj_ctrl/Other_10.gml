///
/// @description Update canvas dimensions

if (live_call()) return live_result;


var w = window_get_width()//browser_width;
var h = window_get_height()//browser_height;

if global.is_browser = 1 {
	w = browser_width;
	h = browser_height;	
}

// find screen pixel dimensions:
if global.is_browser = 1 && global.is_reddit = 0 {
	global.pr = browser_get_device_pixel_ratio();
} else {
	global.pr = 1
}

if global.is_reddit = 1 {
	global.pr = 1
}

//global.pr = 1

show_debug_message("global.pr: "+string(global.pr))

var rw = w * global.pr;
var rh = h * global.pr;

view_wport[0] = rw;
view_hport[0] = rh;
global.sw = rw
global.sh = rh

global.ar = global.sw/global.sh

show_debug_message("global.ar: "+string(global.ar))
//global.sw_s = global.sw*global.pr
//global.sh_s = global.sh*global.pr

//if global.sw >= global.sh {
//	global.is_landscape = 1
//	//show_debug_message("AHHH")
//} else {
//	global.is_landscape = 0	
//	//show_debug_message("OKAY")
//}

global.is_landscape = 0	//reset

// update room/view size:

var _tile_sz_and_pad = global.tile_size+global.pad_size

global.cam_zoom = (((_tile_sz_and_pad*global.game_grid_size)+100)/w)*1.5

if global.ar >= 0.68 {
	show_debug_message("landscape")
	global.is_landscape = 1
	global.cam_zoom = (((_tile_sz_and_pad*global.game_grid_size)+50)/h)*2.8
} else {
	global.is_landscape = 0
	show_debug_message("portrait")	
}

show_debug_message("global.cam_zoom: "+string(global.cam_zoom))


//scr_update_room_dimensions(w*global.cam_zoom,h*global.cam_zoom)
camera_set_view_size(view_camera[0], w*global.cam_zoom, h*global.cam_zoom);
//center cam
camera_set_view_pos(view_camera[0],-(w*global.cam_zoom/2),(-h*global.cam_zoom/2))


//display_set_gui_maximize(global.pr,global.pr)
//display_set_gui_size(rw,rh)

//sbox_top = (global.sh*0.5)+(global.sw*-0.5)
//sbox_btm = (global.sh*0.5)+(global.sw*0.5)
//sbox_ymarg = (global.sh-global.sw)*0.5

//if global.is_landscape = 1 {
//	sbox_top = (global.sh*0.0)//+(global.sw*-0.5)
//	sbox_btm = (global.sh*1.0)//+(global.sw*0.5)
//}

// resize application_surface, if needed
if (application_surface_is_enabled()) {
	surface_resize(application_surface, rw, rh);
	show_debug_message("application_surface_is_enabled = 1")
} else {
	show_debug_message("application_surface_is_enabled = 0")	
}

show_debug_message("resizing surface: "+string(rw)+", "+string(rh))

// set window size to screen pixel size:
//

if global.is_browser = 1 && global.is_reddit = 0 {
window_set_size(rw, rh);
// set canvas size to page pixel size:
browser_stretch_canvas(w, h); 
}

/* for reddit, need to alter main.ts's ensureAspectRatio() to include at the end

	"
	//Fermenter added to set canvas element width (not style width) to match window bounds * devicePixelRatio, adapted from YellowAfterlife's browser_hdpi extension
    console.log("window.devicePixelRatio:")
    console.log(window.devicePixelRatio)
    this.canvasElement.height = window.innerHeight*window.devicePixelRatio; //`${newHeight}`;
    this.canvasElement.width = window.innerWidth*window.devicePixelRatio; //`${newWidth}`;
	"
	
*/
