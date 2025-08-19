// Script: refill_board

function refill_board() {
    // --- الجزء الأول: هبوط الأرقام الموجودة ---

    // سنمر على كل الأعمدة، من اليسار لليمين
    for (var i = 0; i < grid_width; i++) {

        // سنمر على كل الصفوف في العمود الحالي، ولكن من الأسفل للأعلى (مهم جدًا)
        for (var j = grid_height - 1; j >= 0; j--) {

            // إذا كانت هذه الخانة فارغة...
            if (game_grid[# i, j] == noone) {

                // ...سنبدأ بالبحث عن أول رقم فوقها
                var _found_instance = noone;
                for (var _look_above = j - 1; _look_above >= 0; _look_above--) {
                    if (game_grid[# i, _look_above] != noone) {
                        _found_instance = game_grid[# i, _look_above];

                        // وجدنا الرقم! الآن ننقله منطقيًا
                        game_grid[# i, j] = _found_instance; // انقله للخانة الفارغة
                        game_grid[# i, _look_above] = noone; // اجعل مكانه القديم فارغًا

                        // حدّث معلومات الكائن نفسه عن موقعه الجديد
                        _found_instance.grid_y = j;

                        break; // توقف عن البحث لأننا وجدنا أول رقم
                    }
                }
            }
        }
    }

    // --- الجزء الثاني: إنشاء أرقام جديدة في الفراغات العلوية ---

    // مر على الشبكة مرة أخرى، هذه المرة من الأعلى للأسفل
    for (var i = 0; i < grid_width; i++) {
        for (var j = 0; j < grid_height; j++) {

            // إذا كانت الخانة لا تزال فارغة (وهذا يعني أنها في أعلى الشبكة)
            if (game_grid[# i, j] == noone) {
                // حساب الموضع على الشاشة
                var _pos_x = start_x + (i * cell_size) + (cell_size / 2);
                var _pos_y = start_y + (j * cell_size) + (cell_size / 2) - 75;

                // إنشاء كائن رقم جديد
                var _new_number = instance_create_layer(_pos_x, _pos_y, "Instances", obj_number);

                // ربط الكائن بالشبكة وتحديث معلوماته
                game_grid[# i, j] = _new_number.id;
                _new_number.grid_x = i;
                _new_number.grid_y = j;
            }
        }
    }
}