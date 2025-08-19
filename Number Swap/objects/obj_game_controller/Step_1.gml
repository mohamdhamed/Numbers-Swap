

if (shake_time > 0) {
    shake_time--;
    var _x_offset = random_range(-shake_intensity, shake_intensity);
    var _y_offset = random_range(-shake_intensity, shake_intensity);

    // احصل على كاميرا العرض الحالية
    var _view_camera = view_camera[0];
    // احصل على موضع الكاميرا الحالي
    var _cam_x = camera_get_view_x(_view_camera);
    var _cam_y = camera_get_view_y(_view_camera);

    // قم بتعيين الموضع الجديد مع الهزة
    camera_set_view_pos(_view_camera, _cam_x + _x_offset, _cam_y + _y_offset);

    if (shake_time <= 0) {
        // أعد الكاميرا إلى وضعها الأصلي (اختياري، لكنه يضمن عدم بقاء الكاميرا مهتزة)
         camera_set_view_pos(_view_camera, 0, 0); // افترض أن الكاميرا تبدأ من 0,0
    }
}