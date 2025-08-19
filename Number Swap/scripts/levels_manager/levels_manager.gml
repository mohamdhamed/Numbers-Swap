// Script: levels_manager

// -- قاعدة بيانات المستويات --
// هنا نقوم بتعريف كل مستويات اللعبة باستخدام Structs
// كل مستوى هو عبارة عن Struct يحتوي على بياناته الخاصة.


// -- دوال مساعدة --

/// @function get_current_level()
/// @description إرجاع بيانات المستوى الحالي
function get_current_level() {
    if (global.current_level_index < array_length(global.levels)) {
        return global.levels[global.current_level_index];
    }
    return undefined;
}

/// @function get_level_by_id(level_id)
/// @description إرجاع بيانات مستوى معين بناءً على ID
/// @param {real} level_id
function get_level_by_id(level_id) {
    for (var i = 0; i < array_length(global.levels); i++) {
        if (global.levels[i].level_id == level_id) {
            return global.levels[i];
        }
    }
    return undefined;
}

/// @function advance_to_next_level()
/// @description الانتقال للمستوى التالي
function advance_to_next_level() {
    if (global.current_level_index < array_length(global.levels) - 1) {
        global.current_level_index++;
        return true;
    }
    return false; // لا يوجد مستوى تالٍ
}

/// @function calculate_stars(score, level_data)
/// @description حساب عدد النجوم بناءً على الأداء
/// @param {real} score
/// @param {struct} level_data
function calculate_stars(score, level_data) {
    var stars = 0;
    var thresholds = level_data.star_thresholds;
    
    if (score >= thresholds[0]) stars = 1;
    if (score >= thresholds[1]) stars = 2;
    if (score >= thresholds[2]) stars = 3;
    
    return stars;
}

/// @function is_level_unlocked(level_id)
/// @description التحقق من إذا كان المستوى مفتوحاً
/// @param {real} level_id
function is_level_unlocked(level_id) {
    // المستوى الأول مفتوح دائماً
    if (level_id == 1) return true;
    
    // المستويات الأخرى تحتاج إكمال المستوى السابق
    return (global.player_progress.levels_completed >= level_id - 1);
}

/// @function complete_level(score, moves_used)
/// @description إتمام المستوى وحفظ التقدم
/// @param {real} score
/// @param {real} moves_used
function complete_level(score, moves_used) {
    var current_level = get_current_level();
    if (current_level == undefined) return;
    
    var stars = calculate_stars(score, current_level);
    var level_id = current_level.level_id;
    
    // تحديث التقدم
    if (level_id > global.player_progress.levels_completed) {
        global.player_progress.levels_completed = level_id;
    }
    
    // حفظ النجوم (إذا كانت أفضل من السابق)
    if (array_length(global.player_progress.level_stars) < level_id) {
        array_resize(global.player_progress.level_stars, level_id);
    }
    
    var previous_stars = global.player_progress.level_stars[level_id - 1] || 0;
    if (stars > previous_stars) {
        global.player_progress.level_stars[level_id - 1] = stars;
        global.player_progress.total_stars += (stars - previous_stars);
    }
    
    // تحديث أعلى نقاط
    if (score > global.player_progress.highest_score) {
        global.player_progress.highest_score = score;
    }
    
    show_debug_message("Level " + string(level_id) + " completed with " + string(stars) + " stars!");
}

/// @function reset_progress()
/// @description إعادة تعيين التقدم (للاختبار)
function reset_progress() {
    global.current_level_index = 0;
    global.player_progress = {
        levels_completed: 0,
        total_stars: 0,
        highest_score: 0,
        level_stars: []
    };
}

/// @function get_total_levels()
/// @description إرجاع العدد الكلي للمستويات
function get_total_levels() {
    return array_length(global.levels);
}