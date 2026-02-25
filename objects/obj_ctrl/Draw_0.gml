if (live_call()) return live_result;






var _letter_hue = 150
global.background_col = make_color_hsv(_letter_hue,130,60)
global.border_col = make_color_hsv(_letter_hue,140,50)

if global.light_mode = 1 {
global.background_col = make_color_hsv(30,0,225)
global.background_col = make_color_hsv(30,20,230)
global.border_col = make_color_hsv(25,50,200)
}

var background = layer_background_get_id(layer_get_id("Background"));
layer_background_blend(background, global.background_col)


if global.game_phase >= 3 {
	var _board_sz = (global.game_grid_size*32)*1.03
	draw_sprite_ext(spr_sqr512,0,0,0,_board_sz/256,_board_sz/256,0,global.border_col,1) //merge_colour(global.background_col,c_black,0.4)
}


//with (obj_tile_letter) {

//	var _tile_ht = 0
//	var _tile_rot = 0
//	var _tile_scl = 1
//	var _spawn_slam = spawn_slam
//	draw_sprite_ext(spr_sqr512,0,x+lengthdir_x(-_tile_ht,image_angle-90),y+lengthdir_y(-_tile_ht,image_angle-90)+_spawn_slam,image_xscale*_tile_scl*1.1,image_yscale*_tile_scl*1.1,image_angle+_tile_rot,merge_colour(global.background_col,c_black,0.4),1)
	
	
	
//}

//draw_clear(make_color_hsv(_letter_hue,110,50))

//draw_sprite(spr_sqr512,1,mouse_x,mouse_y)
if keyboard_check(vk_control) {

draw_set_color(c_red)
draw_rectangle((0)-((140)*global.cam_zoom),(0)-((280)*global.cam_zoom),(0)+((140)*global.cam_zoom),(0)+((280)*global.cam_zoom),1)

draw_set_color(c_blue)
draw_rectangle((0)-((140)*2),(0)-((280)*2),(0)+((140)*2),(0)+((280)*2),1)

//global.game_grid_size = 4

var _tile_sz_and_pad = global.tile_size+global.pad_size

draw_set_color(c_red)
draw_circle(global.grid_x_origin,0,global.game_grid_size*_tile_sz_and_pad*0.5*global.cam_zoom,1)

draw_set_color(c_blue)
draw_circle(global.grid_x_origin,0,global.game_grid_size*_tile_sz_and_pad*0.5*2,1)

}

