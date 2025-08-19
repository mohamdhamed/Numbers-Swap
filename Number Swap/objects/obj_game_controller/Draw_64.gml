// Draw GUI Event for obj_game_controller

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

// --- إعدادات الرسم ---
draw_set_font(fnt_ui);
draw_set_valign(fa_top);
draw_set_color(c_white);

// --- رسم الهدف (متغير الآن) ---
draw_set_halign(fa_left);
var _objective_text = "";
var _current_level = get_current_level();

if (_current_level.objective_type == "score") {
    _objective_text = "Score: " + string(current_score) + " / " + string(_current_level.objective_value);
} 
else if (_current_level.objective_type == "clear_color") {
    var _target_color = _current_level.objective_value;
    var _cleared_count = colors_cleared[? _target_color] ?? 0;
    _objective_text = "Clear Reds: " + string(_cleared_count) + " / " + string(_current_level.objective_target_count);
    // ملاحظة: يمكنك جعل هذا النص أكثر ديناميكية ليدعم كل الألوان
}

draw_text(5, 50, _objective_text);

// --- رسم الحركات المتبقية (Moves) ---
draw_set_halign(fa_right);
var _moves_text = "Moves: " + string(moves_left);
draw_text(_gui_width - 5, 50, _moves_text);

// --- رسم رقم المستوى الحالي ---
draw_set_halign(fa_center);
var _level_text = "Level " + string(global.current_level_index + 1);
draw_text(_gui_width / 2, 5, _level_text);

// إعادة المحاذاة الافتراضية
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// لا نرسم أي شيء إذا لم يكن اللاعب يحدد أرقامًا
// لا نرسم المربع إلا إذا كان اللاعب يسحب حاليًا
if (is_selecting && ds_list_size(selection_list) > 0)  {

    // -- 1. إعدادات الرسم --ب
    var _box_width = 200; // عرض المربع
    var _box_height = 120; // ارتفاع المربع
    var _x_pos = (_gui_width / 2); // منتصف الشاشة أفقيًا
    var _y_pos = 180; // المسافة من أعلى الشاشة

    // -- 2. رسم خلفية المربع --
    // نرسم مربعًا أسود شبه شفاف
    draw_set_alpha(0.7);
    draw_rectangle_color(
        _x_pos - (_box_width / 2),
        _y_pos - (_box_height / 2),
        _x_pos + (_box_width / 2),
        _y_pos + (_box_height / 2),
        c_black, c_black, c_black, c_black, false
    );
    draw_set_alpha(1); // أعد الشفافية لوضعها الطبيعي

    // -- 3. رسم نص المجموع --
    draw_set_font(fnt_ui);             // استخدم الخط الكبير الذي أنشأناه
    draw_set_halign(fa_center);        // محاذاة أفقية
    draw_set_valign(fa_middle);       // محاذاة رأسية
    draw_set_color(c_white);           // لون النص

    draw_text(_x_pos, _y_pos, current_sum); // ارسم قيمة المجموع
}
// --- رسم رسائل الفوز أو الخسارة ---
// --- رسم رسائل الفوز أو الخسارة ---
if (game_state != "playing") {

    // -- 1. إعدادات المربع المنبثق --
    var _box_width = 550; // عرض المربع
    var _box_height = 300; // ارتفاع المربع
    var _box_x = _gui_width / 2; // منتصف الشاشة أفقيًا
    var _box_y = _gui_height / 2 - 100; // الموضع الرأسي للمربع

    // -- 2. رسم خلفية المربع --
    draw_set_color(c_black);
    draw_set_alpha(0.8); // درجة شفافية أعلى قليلاً
    // استخدم draw_roundrect لرسم مربع بحواف دائرية لمظهر أجمل
    draw_roundrect_colour(
        _box_x - (_box_width / 2), 
        _box_y - (_box_height / 2), 
        _box_x + (_box_width / 2), 
        _box_y + (_box_height / 2), 
        c_black, c_black, false
    );
    draw_set_alpha(1); // أعد الشفافية لوضعها الطبيعي

    // -- 3. إعدادات الخط للرسالة الكبيرة --
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_font(fnt_ui);

    var _message = "";
    if (game_state == "won") {
        _message = "Level Complete!";
    } else { // game_state == "lost"
        _message = "You Lost!";
    }

    // -- 4. ارسم الرسالة في منتصف المربع --
    draw_text(_box_x, _box_y, _message);
}