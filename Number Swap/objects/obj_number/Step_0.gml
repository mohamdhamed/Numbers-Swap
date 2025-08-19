// داخل Step Event لـ obj_number

// حساب الموضع المستهدف بناءً على موقع الكائن في الشبكة
var _target_x = obj_game_controller.start_x + (grid_x * obj_game_controller.cell_size) + (obj_game_controller.cell_size / 2);
var _target_y = obj_game_controller.start_y + (grid_y * obj_game_controller.cell_size) + (obj_game_controller.cell_size / 2);

current_scale = lerp(current_scale, target_scale, 0.2)

// اقترب تدريجيًا من الموضع المستهدف
x = lerp(x, _target_x, 0.2);
y = lerp(y, _target_y, 0.2);