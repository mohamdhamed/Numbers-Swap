// داخل Draw Event لـ obj_number

// أولاً: حدد الحجم المستهدف بناءً على حالة الاختيار
if (is_selected) {
    target_scale = 1.2; // اجعله أكبر عندما يكون محدداً
    draw_sprite_ext(sprite_index, image_index, x, y, current_scale, current_scale, image_angle, c_red, 1);
} else {
    target_scale = 1; // أعده للحجم الطبيعي
    draw_sprite_ext(sprite_index, image_index, x, y, current_scale, current_scale, image_angle, image_blend, 1);
}

// ثانياً: جهز إعدادات الخط
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_main);
draw_set_color(c_white);

// ثالثاً: ارسم الرقم (مع تغيير حجمه أيضاً)
// نرسم النص بحجم يتناسب مع حجم المربع
draw_text_transformed(x, y, my_value, current_scale, current_scale, 0);