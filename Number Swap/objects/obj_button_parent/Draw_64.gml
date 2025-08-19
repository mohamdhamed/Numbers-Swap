// Draw Event for obj_button_parent
var _box_color = c_black;
var _text_color = c_white;
var _scale = 1;

if (is_hovered) {
    _box_color = c_dkgray; // تغيير اللون عند مرور الفأرة
    _scale = 1.05; // تكبير النص قليلاً
}

// رسم خلفية الزر
draw_set_alpha(0.7);
draw_rectangle_color(x - (width/2), y - (height/2), x + (width/2), y + (height/2), _box_color, _box_color, _box_color, _box_color, false);
draw_set_alpha(1);

// رسم النص
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_ui);
draw_set_color(_text_color);
draw_text_transformed(x, y, button_text, _scale, _scale, 0);