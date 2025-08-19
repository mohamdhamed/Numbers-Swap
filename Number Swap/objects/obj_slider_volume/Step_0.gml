// Step Event for obj_slider_volume
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _mouse_check = mouse_check_button(mb_left);

if (mouse_check_button_pressed(mb_left) && point_in_rectangle(_mouse_x, _mouse_y, x - width/2, y - height/2, x + width/2, y + height/2)) {
    is_dragging = true;
}

if (!_mouse_check) {
    is_dragging = false;
}

if (is_dragging) {
    // تحديث قيمة الصوت بناءً على موقع الفأرة
    var _slider_start_x = x - width/2;
    var _new_val = (_mouse_x - _slider_start_x) / width;
    global.master_volume = clamp(_new_val, 0, 1); // clamp للتأكد أن القيمة بين 0 و 1

    audio_master_gain(global.master_volume); // تطبيق مستوى الصوت مباشرة
}