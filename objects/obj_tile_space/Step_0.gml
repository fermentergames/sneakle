if (live_call()) return live_result;

if global.game_phase = 1 {
	
	tile_filled = 0 //reset

	var _col_tile = collision_point(x,y,obj_tile_letter,true,true)

	if _col_tile != noone {
		if _col_tile.am_set = 1 && _col_tile.am_dragging = 0 {
			tile_filled = 1	
		}
	}

} else {
	tile_filled = 1	
}



//if tile_filled = 0 {
//	if mouse_check_button_pressed(mb_left) {
//		if collision_point(mouse_x,mouse_y,self,true,false) {
			


//		}
	
//	}

//}

