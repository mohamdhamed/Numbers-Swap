// نحصل على إحداثيات الفأرة للواجهة
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

// التحقق مما إذا كان مؤشر الفأرة داخل حدود الزر
if (point_in_rectangle(_mouse_x, _mouse_y, x - (width/2), y - (height/2), x + (width/2), y + (height/2))) {
    is_hovered = true;
} else {
    is_hovered = false;
}

// -- الكود الجديد والأكثر أمانًا --
// نستخدم دالة حديثة للتحقق من وجود المتغير في هذا الكائن تحديداً
if (variable_instance_exists(id, "action")) {
    // التحقق من النقر فقط إذا كان الفأرة فوق الزر
    if (is_hovered && device_mouse_check_button_pressed(0, mb_left)) {
        action(); // قم بتنفيذ الأمر
    }
}