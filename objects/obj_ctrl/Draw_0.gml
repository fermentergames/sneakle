if (live_call()) return live_result;

//draw_clear(make_color_hsv(160,10,170))

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

