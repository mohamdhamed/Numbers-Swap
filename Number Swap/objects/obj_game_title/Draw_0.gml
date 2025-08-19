// Draw Event for obj_game_title
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ارسم اسم اللعبة بخط كبير في منتصف الشاشة العلوي
draw_set_font(fnt_ui); // استخدم الخط الكبير
draw_set_color(c_white);
draw_text(room_width / 2, 200, "Number Swap");