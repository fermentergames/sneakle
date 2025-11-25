if (live_call()) return live_result;

image_xscale = 0
image_yscale = image_xscale

scl = 0

am_set = 0
am_set_flash = 0
am_set_flash2 = 0
am_set_fd = 0

am_dragging = 0

am_dragging_flash = 0
am_dragging_flash2 = 0
am_dragging_fd = 0

am_being_pushed = 0
am_being_pushed_fd = 0

am_selected = 0
am_selected_flash = 0
am_selected_flash2 = 0
am_selected_fd = 0

am_selected_start = 0
am_selected_end = 0
am_selected_num = 0

am_exed = 0
am_exed_fd = 0
am_clued = 0
am_clued_fd = 0
am_clued_flash = 0
am_clued_flash2 = 0
am_clued_won = 0
am_clued_won_fd = 0

am_samelettered = 0
am_samelettered_fd = 0


targ_id = self//instance_nearest(x,y,obj_tile_space)
x_targ = targ_id.x
y_targ = targ_id.y

prev_targ_id = self

my_letter_num = -1
my_letter_str = "X"

born_fd = 0
spawn_slam = 1+random(0.2)

am_part_of_secret_word = 0
am_part_of_secret_word_fd = 0
am_part_of_secret_word_order = -1
image_blend_base = image_blend



tile_going_to_replace = 0




