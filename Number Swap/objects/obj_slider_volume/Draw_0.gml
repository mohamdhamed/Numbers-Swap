// Draw Event for obj_slider_volume
var _slider_x = x - width/2;
var _slider_y = y - height/2;
var _handle_pos_x = _slider_x + (width * global.master_volume);

// رسم شريط السلايدر
draw_set_color(c_black);
draw_rectangle(_slider_x, _slider_y, _slider_x + width, _slider_y + height, false);
draw_set_color(c_green);
draw_rectangle(_slider_x, _slider_y, _handle_pos_x, _slider_y + height, false);

// رسم مؤشر السلايدر
draw_set_color(c_white);
draw_rectangle(_handle_pos_x - 5, _slider_y - 10, _handle_pos_x + 5, _slider_y + height + 10, false);

// رسم عنوان "Volume"
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(x, y - height/2 - 10, "Volume");