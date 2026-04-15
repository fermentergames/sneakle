if (live_call()) return live_result;


//if my_letter_num != 0 {
//	//my_letter_str	
//}





if am_dragging = 1 {
	
	//targ_id = self//instance_nearest(x,y,obj_tile_space)
	x_targ = mouse_x
	y_targ = mouse_y-25+(obj_ctrl.pulse_2*3)+((clamp(-1+(am_hoverchanged_flash*20),0,1))*-60)
	
	
}

swipe_radius = 29//reset
//make target area smaller on already selected letters for less accidental undos
if am_selected >= 1 {
	swipe_radius = 25
}


am_being_pushed = 0 //reset

if am_set = 0 && am_dragging = 0 {
	
	var _conflicting_tile = collision_circle(x,y,50*scl,obj_tile_letter,true,true)
		
	if _conflicting_tile != noone {
		
		//if _conflicting_tile.am_being_pushed >= 1 {
			
		//} else {
		//	if collision_circle(x,y,20,_conflicting_tile,true,true) {
				
		//	} else {
		//		_conflicting_tile = noone
		//	}
		//}
		
		if _conflicting_tile.am_dragging = 0 {
		
			x_targ += (x-_conflicting_tile.x)*0.2
			y_targ += (y-_conflicting_tile.y)*0.2
		
			am_being_pushed = 1
		
		}
		
	}
	
	var _left_bound = global.grid_x_origin-140*global.cam_zoom
	var _right_bound = global.grid_x_origin+140*global.cam_zoom
	
	var _top_bound = global.grid_y_origin
	var _bottom_bound = global.grid_y_origin+280*global.cam_zoom
	
	
	if x < _left_bound {
		x_targ += (x-_left_bound)*-0.2*am_being_pushed_fd
		am_being_pushed = 1
	}
	
	if x > _right_bound {
		x_targ += (x-(_right_bound))*-0.2*am_being_pushed_fd
		am_being_pushed = 1
	}
	
	if y < _top_bound {
		y_targ += (y-(_top_bound))*-0.2*am_being_pushed_fd
		am_being_pushed = 1
	}
	
	if y > _bottom_bound {
		y_targ += (y-(_bottom_bound))*-0.2*am_being_pushed_fd
		am_being_pushed = 1
	}
	
}



var _fast_lerp = clamp(am_set-am_dragging,0,1)
var _settle_epsilon = 0.001
var _move_lerp = 0.2+(0.3*_fast_lerp)

if abs(x-x_targ) > _settle_epsilon {
	x = lerp(x,x_targ,_move_lerp)
} else {
	x = x_targ
}
if abs(y-y_targ) > _settle_epsilon {
	y = lerp(y,y_targ,_move_lerp)
} else {
	y = y_targ
}

var _dragging_or_set = clamp(am_dragging_fd+am_set_fd,0,1)

scl = 0.125*(0.8+(0.2*_dragging_or_set)+(0.4*am_dragging_flash2)+(-0.6*am_set_flash2)+(0.0*am_selected_flash2))


image_xscale = scl
image_yscale = image_xscale

if abs(am_set_fd-am_set) > _settle_epsilon {
	am_set_fd = lerp(am_set_fd,am_set,0.2)
} else {
	am_set_fd = am_set
}
if am_set_flash > _settle_epsilon {
	am_set_flash = lerp(am_set_flash,0,0.3)
} else {
	am_set_flash = 0
}
if abs(am_set_flash2-am_set_flash) > _settle_epsilon {
	am_set_flash2 = lerp(am_set_flash2,am_set_flash,0.5)
} else {
	am_set_flash2 = am_set_flash
}

if abs(am_dragging_fd-am_dragging) > _settle_epsilon {
	am_dragging_fd = lerp(am_dragging_fd,am_dragging,0.4)
} else {
	am_dragging_fd = am_dragging
}
if am_dragging_flash > _settle_epsilon {
	am_dragging_flash = lerp(am_dragging_flash,0,0.1)
} else {
	am_dragging_flash = 0
}
if abs(am_dragging_flash2-am_dragging_flash) > _settle_epsilon {
	am_dragging_flash2 = lerp(am_dragging_flash2,am_dragging_flash,0.4)
} else {
	am_dragging_flash2 = am_dragging_flash
}

if am_hoverchanged_flash > _settle_epsilon {
	am_hoverchanged_flash = lerp(am_hoverchanged_flash,0,0.06)
} else {
	am_hoverchanged_flash = 0
}

if abs(am_being_pushed_fd-am_being_pushed) > _settle_epsilon {
	am_being_pushed_fd = lerp(am_being_pushed_fd,am_being_pushed,0.3)
} else {
	am_being_pushed_fd = am_being_pushed
}

if abs(am_selected_fd-am_selected) > _settle_epsilon {
	am_selected_fd = lerp(am_selected_fd,am_selected,0.2)
} else {
	am_selected_fd = am_selected
}
if am_selected_flash > _settle_epsilon {
	am_selected_flash = lerp(am_selected_flash,0,0.1)
} else {
	am_selected_flash = 0
}
if abs(am_selected_flash2-am_selected_flash) > _settle_epsilon {
	am_selected_flash2 = lerp(am_selected_flash2,am_selected_flash,0.4)
} else {
	am_selected_flash2 = am_selected_flash
}

if abs(am_exed_fd-am_exed) > _settle_epsilon {
	am_exed_fd = lerp(am_exed_fd,am_exed,0.2)
} else {
	am_exed_fd = am_exed
}
if abs(am_clued_fd-am_clued) > _settle_epsilon {
	am_clued_fd = lerp(am_clued_fd,am_clued,0.2)
} else {
	am_clued_fd = am_clued
}
if abs(am_samelettered_fd-am_samelettered) > _settle_epsilon {
	am_samelettered_fd = lerp(am_samelettered_fd,am_samelettered,0.2)
} else {
	am_samelettered_fd = am_samelettered
}

if am_clued_flash > _settle_epsilon {
	am_clued_flash = lerp(am_clued_flash,0,0.1)
} else {
	am_clued_flash = 0
}
if abs(am_clued_flash2-am_clued_flash) > _settle_epsilon {
	am_clued_flash2 = lerp(am_clued_flash2,am_clued_flash,0.4)
} else {
	am_clued_flash2 = am_clued_flash
}

if abs(am_clued_won_fd-am_clued_won) > _settle_epsilon {
	am_clued_won_fd = lerp(am_clued_won_fd,am_clued_won,0.1)
} else {
	am_clued_won_fd = am_clued_won
}

var _secret_word_targ = am_part_of_secret_word
if global.game_phase < 3 {
	_secret_word_targ = am_part_of_secret_word
} else if global.game_phase = 3 {
	_secret_word_targ = 0
} else {
	_secret_word_targ = am_part_of_secret_word
}
if abs(am_part_of_secret_word_fd-_secret_word_targ) > _settle_epsilon {
	am_part_of_secret_word_fd = lerp(am_part_of_secret_word_fd,_secret_word_targ,0.2)
} else {
	am_part_of_secret_word_fd = _secret_word_targ
}

if abs(born_fd-1) > _settle_epsilon {
	born_fd = lerp(born_fd,1,0.05)
} else {
	born_fd = 1
}

if spawn_slam > 0 {
	spawn_slam -= 0.05
	spawn_slam = lerp(spawn_slam,0,0.02)
	
	if spawn_slam <= 0 {
		spawn_slam = 0
		am_set_flash = 1	
	}
}





if am_set = 0 || am_dragging = 1 {
	var _ang_targ = (x-x_targ)*1
	image_angle -= angle_difference(image_angle,_ang_targ)*0.06*clamp(am_dragging_fd+am_being_pushed,0,1)
} else {
	var _tile_ang = 0//+(2*global.am_creating_fd2*(sin((-1*tile_id)+(obj_ctrl.timey*0.1))))
	if abs(image_angle-_tile_ang) > _settle_epsilon {
		image_angle -= angle_difference(image_angle,_tile_ang)*0.3
	} else {
		image_angle = _tile_ang
	}
}


if tile_going_to_replace > 0 {
	tile_going_to_replace -= 0.2 //reset
}

tile_going_to_replace_id = noone

if am_dragging = 1 {
	var _col_tile = collision_point(mouse_x,mouse_y,obj_tile_letter,true,true)
	
	if _col_tile != noone {
		if _col_tile.am_set = 1 && _col_tile.am_dragging = 0 {
			_col_tile.tile_going_to_replace = 1
			tile_going_to_replace_id = _col_tile.id
		}
	}
}

//if am_hovered > 0 { //reset
//	am_hovered -= 0.25
//}

//if global.is_mobile = 0 {
//	if tile_going_to_replace <= 0 {
//		if collision_point(mouse_x,mouse_y,self,true,0)	{
//			am_hovered += 0.5
//			am_hovered = clamp(am_hovered,0,1)
//		}
//	} else {
//		am_hovered = 0
//	}
//}

