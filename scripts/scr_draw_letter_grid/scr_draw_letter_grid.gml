///

function scr_draw_letter_grid(grid_string, center_x, center_y, row_len, cell_size, scl)
{
	if (live_call(argument0,argument1,argument2,argument3,argument4,argument5)) return live_result;
   var len = string_length(grid_string);

   // total grid dimensions
   var grid_w = row_len * cell_size;
   var grid_h = row_len * cell_size;

   // top-left corner so the grid is centered
   var start_x = center_x - grid_w * 0.5;
   var start_y = center_y - grid_h * 0.5;

   for (var i = 0; i < len; i++)
   {
      var col = i mod row_len;
      var row = i div row_len;

      var letter = string_char_at(grid_string, i + 1);

      var xx = start_x + col * cell_size + cell_size * 0.5;
      var yy = start_y + row * cell_size + cell_size * 0.5;

		draw_sprite_ext(spr_sqr512_tile_dotted,1,xx,yy,cell_size/512,cell_size/512,0,draw_get_colour(),0.1)
      draw_text_transformed(xx, yy, letter, scl, scl, 0);
   }
}
