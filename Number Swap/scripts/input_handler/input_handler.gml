// Script: input_handler
// Enhanced input handling with better organization and additional features

/// @description Handle all touch/mouse input for the game
function handle_game_input() {
    
    // --- 1. الحصول على إحداثيات اللمس ---
    var _touch_x = device_mouse_x_to_gui(0);
    var _touch_y = device_mouse_y_to_gui(0);

    // =================================================================
    //  الجزء الأول: منطق اللعب (يعمل فقط عندما تكون اللعبة في حالة "لعب")
    // =================================================================
    if (game_state == "playing") {
        
        // --- التحقق من بدء اللمس ---
        if (device_mouse_check_button_pressed(0, mb_left)) {
            start_selection(_touch_x, _touch_y);
        }

        // --- التحقق من استمرار السحب ---
        if (is_selecting) {
            update_selection(_touch_x, _touch_y);
            update_current_sum(); // تحديث المجموع الفوري
        }
        
    } // نهاية if (game_state == "playing")

    // =================================================================
    //  الجزء الثاني: منطق إنهاء الحركة (يعمل دائماً عند رفع الإصبع)
    // =================================================================
    if (device_mouse_check_button_released(0, mb_left)) {
        if (is_selecting) {
            finish_selection();
        }
    }
}

/// @description بدء عملية الاختيار
/// @param {real} touch_x
/// @param {real} touch_y
function start_selection(touch_x, touch_y) {
    var _selected_instance = instance_position(touch_x, touch_y, obj_number);
    if (_selected_instance != noone) {
        is_selecting = true;
        selection_dx = 0;
        selection_dy = 0;
        ds_list_clear(selection_list);
        ds_list_add(selection_list, _selected_instance.id);
        _selected_instance.is_selected = true;
        
        // تأثيرات بصرية/صوتية للبداية
        audio_play_sound(snd_select_start, 1, false);
    }
}

/// @description تحديث الاختيار أثناء السحب
/// @param {real} touch_x
/// @param {real} touch_y
function update_selection(touch_x, touch_y) {
    var _current_instance = instance_position(touch_x, touch_y, obj_number);
    if (_current_instance != noone) {
        
        // تحقق من أن هذا الكائن ليس محدداً مسبقاً
        if (ds_list_find_index(selection_list, _current_instance.id) == -1) {
            var _list_size = ds_list_size(selection_list);
            var _last_instance_id = ds_list_find_value(selection_list, _list_size - 1);
            
            var _can_add = false;
            
            if (_list_size == 1) {
                // أول إضافة: تحقق من الجوار
                if (is_adjacent(_current_instance, _last_instance_id)) {
                    _can_add = true;
                    selection_dx = _current_instance.grid_x - _last_instance_id.grid_x;
                    selection_dy = _current_instance.grid_y - _last_instance_id.grid_y;
                }
            } else {
                // الإضافات التالية: تحقق من نفس الاتجاه
                var _expected_x = _last_instance_id.grid_x + selection_dx;
                var _expected_y = _last_instance_id.grid_y + selection_dy;
                if (_current_instance.grid_x == _expected_x && _current_instance.grid_y == _expected_y) {
                    _can_add = true;
                }
            }
            
            if (_can_add) {
                ds_list_add(selection_list, _current_instance.id);
                _current_instance.is_selected = true;
                
                // تأثيرات بصرية/صوتية للإضافة
                audio_play_sound(snd_select_add, 1, false);
            }
        }
    }
}

/// @description تحديث المجموع الفوري
function update_current_sum() {
    current_sum = 0;
    for (var i = 0; i < ds_list_size(selection_list); i++) {
        var _inst = ds_list_find_value(selection_list, i);
        if (instance_exists(_inst)) {
            current_sum += _inst.my_value;
        }
    }
}

/// @description التحقق من الجوار بين كائنين
/// @param {instance} inst1
/// @param {instance} inst2
function is_adjacent(inst1, inst2)
{
    return (abs(inst1.grid_x - inst2.grid_x) <= 1 && abs(inst1.grid_y - inst2.grid_y) <= 1);
}

/// @description إنهاء عملية الاختيار ومعالجة النتيجة
function finish_selection() {
    is_selecting = false; // أوقف عملية الاختيار دائماً

    var _total_sum = calculate_selection_sum();
    var _is_move_successful = false;
    
    // --- التحقق من شرط الحركة الصحيحة (فقط إذا كنا في حالة لعب) ---
    if (game_state == "playing" && is_valid_move(_total_sum)) {
        _is_move_successful = true;
        execute_successful_move(_total_sum);
    } else {
        // حركة غير صحيحة - تأثيرات بصرية/صوتية
        if (game_state == "playing") {
            audio_play_sound(snd_invalid_move, 1, false);
            shake_time = 3;
            shake_intensity = 0.3;
        }
    }
    
    // --- تنظيف الاختيار ---
    clear_selection();
}

/// @description حساب مجموع الاختيار الحالي
function calculate_selection_sum() {
    var _total_sum = 0;
    for (var i = 0; i < ds_list_size(selection_list); i++) {
        var _inst = ds_list_find_value(selection_list, i);
        if (instance_exists(_inst)) {
            _total_sum += _inst.my_value;
        }
    }
    return _total_sum;
}

/// @description التحقق من صحة الحركة
/// @param {real} sum
function is_valid_move(sum) {
    return (sum > 0 && sum % 10 == 0 && ds_list_size(selection_list) > 1);
}

/// @description تنفيذ حركة ناجحة
/// @param {real} total_sum
function execute_successful_move(total_sum) {
    // **تحديث النقاط والحركات**
    var _points_earned = total_sum;
    var _bonus_multiplier = calculate_bonus_multiplier();
    _points_earned *= _bonus_multiplier;
    
    current_score += _points_earned;
    moves_left--;
    
    // تأثيرات بصرية محسنة
    create_score_popup(_points_earned, _bonus_multiplier > 1);
    audio_play_sound(snd_successful_move, 1, false);
    
    // **تدمير الأرقام**
    destroy_selected_numbers();
	// الدالة destroy_selected_numbers()

for (var i = 0; i < ds_list_size(selection_list); i++) {
    var _inst = ds_list_find_value(selection_list, i);
    if (instance_exists(_inst)) {

        // --- >> الكود الجديد الذي يجب إضافته << ---
        var _color = _inst.image_blend; // احصل على لون القطعة
        var _current_count = colors_cleared[? _color] ?? 0; // احصل على العدد الحالي أو 0
        colors_cleared[? _color] = _current_count + 1; // قم بزيادة العدد
        // --- >> نهاية الكود الجديد << ---

        game_grid[# _inst.grid_x, _inst.grid_y] = noone;
        create_destruction_effect(_inst.x, _inst.y);
        instance_destroy(_inst);
    }
}
    
    // **إعادة ملء اللوحة**
    refill_board();
    
    // **تأثيرات الاهتزاز**
    shake_time = 8;
    shake_intensity = ds_list_size(selection_list) * 0.5;
    
    // **التحقق من الفوز أو الخسارة**
    check_game_end_conditions();
}

/// @description حساب مضاعف المكافأة
function calculate_bonus_multiplier() {
    var _selection_size = ds_list_size(selection_list);
    if (_selection_size >= 6) return 2.0;      // مكافأة للسلاسل الطويلة
    if (_selection_size >= 4) return 1.5;      // مكافأة للسلاسل المتوسطة
    return 1.0; // لا مكافأة
}

/// @description إنشاء نص منبثق للنقاط
/// @param {real} points
/// @param {bool} is_bonus
function create_score_popup(points, is_bonus) {
    var _popup = instance_create_layer(room_width / 2, room_height / 2, "UI", obj_score_popup);
    _popup.points = points;
    _popup.is_bonus = is_bonus;
}

/// @description تدمير الأرقام المحددة
function destroy_selected_numbers() {
    for (var i = 0; i < ds_list_size(selection_list); i++) {
        var _inst = ds_list_find_value(selection_list, i);
        if (instance_exists(_inst)) {
            game_grid[# _inst.grid_x, _inst.grid_y] = noone;
            
            // تأثير تدمير بصري
            create_destruction_effect(_inst.x, _inst.y);
            
            instance_destroy(_inst);
        }
    }
}

/// @description إنشاء تأثير التدمير
/// @param {real} x_pos
/// @param {real} y_pos
function create_destruction_effect(x_pos, y_pos) {
    var _effect = instance_create_layer(x_pos, y_pos, "Effects", obj_destruction_particle);
    // يمكن إضافة المزيد من التأثيرات هنا
}

/// @description مسح الاختيار الحالي
function clear_selection() {
    // إلغاء تحديد جميع الكائنات
    for (var i = 0; i < ds_list_size(selection_list); i++) {
        var _inst = ds_list_find_value(selection_list, i);
        if (instance_exists(_inst)) {
            _inst.is_selected = false;
        }
    }
    
    ds_list_clear(selection_list);
    current_sum = 0;
}

/// @description التحقق من شروط انتهاء اللعبة
function check_game_end_conditions() {
    var _level_won = false;
    var _current_level = get_current_level();
    
    if (_current_level == undefined) return;
    
    // تحقق من الهدف بناءً على نوعه
    switch(_current_level.objective_type) {
        case "score":
            if (current_score >= _current_level.objective_value) {
                _level_won = true;
            }
            break;
            
      case "clear_color":
        var _target_color = _current_level.objective_value;
        var _target_count = _current_level.objective_target_count;
        var _cleared_count = colors_cleared[? _target_color] ?? 0;

        if (_cleared_count >= _target_count) {
            _level_won = true;
        }
        break;
    // --- >> نهاية الجزء الجديد << ---

    case "clear_multiple_colors":
        // يمكننا إضافة منطق هذا الهدف لاحقًا
        break;
}
    
    // الآن، تحقق مما إذا تم الفوز بالمستوى
    if (_level_won) {
        handle_level_victory();
    } 
    else if (moves_left <= 0) {
        handle_level_defeat();
    }
}

/// @description التعامل مع الفوز في المستوى
function handle_level_victory() {
    game_state = "won";
    
    // --- >> استدعاء دالة إكمال المستوى << ---
    var _moves_used = get_current_level().moves - moves_left;
    complete_level(current_score, _moves_used);
    
    // تأثيرات الفوز
    audio_play_sound(snd_level_complete, 1, false);
    create_victory_effects();
    
    // إنشاء زر المستوى التالي
   // السطر الصحيح
instance_create_layer(room_width / 2, (display_get_gui_height() / 2) + 50, "UI", obj_button_next_level);
}

/// @description التعامل مع الهزيمة في المستوى
function handle_level_defeat() {
    game_state = "lost";
    
    // تأثيرات الهزيمة
    audio_play_sound(snd_game_over, 1, false);
    
    // إنشاء زر الإعادة
  // السطر الصحيح
instance_create_layer(room_width / 2, (display_get_gui_height() / 2) + 50, "UI", obj_button_retry);
}

/// @description إنشاء تأثيرات الفوز
function create_victory_effects() {
    // يمكن إضافة جزيئات، أضواء، إلخ
    repeat(20) {
        var _particle = instance_create_layer(
            random(room_width), 
            random(room_height), 
            "Effects", 
            obj_victory_particle
        );
    }
}