// Create Event for obj_init
global.master_volume = 1; // 1 = 100% volume

global.levels = [
    // Level 1 - Tutorial Level
    {
        level_id: 1,
        objective_type: "score",
        objective_value: 10,
        moves: 20,
        difficulty: "easy",
        star_thresholds: [8, 12, 15], // نجمة واحدة، نجمتان، ثلاث نجوم
        background_theme: "garden",
        special_pieces: []
    },

    // Level 2 - Score Challenge
    {
        level_id: 2,
        objective_type: "score",
        objective_value: 15,
        moves: 25,
        difficulty: "easy",
        star_thresholds: [12, 18, 22],
        background_theme: "garden",
        special_pieces: ["bomb"] // قطع خاصة متوفرة
    },

    // Level 3 - Color Clear Challenge
    {
        level_id: 3,
        objective_type: "clear_color",
        objective_value: c_lime, // اللون المطلوب
        objective_target_count: 30, // العدد المطلوب
        moves: 25,
        difficulty: "medium",
        star_thresholds: [25, 35, 40], // بناءً على عدد القطع المُزالة
        background_theme: "forest",
        special_pieces: ["bomb", "rainbow"]
    },

    // Level 4 - Multiple Colors
    {
        level_id: 4,
        objective_type: "clear_multiple_colors",
        objective_colors: [c_red, c_blue],
        objective_target_counts: [15, 15], // 15 أحمر، 15 أزرق
        moves: 30,
        difficulty: "medium",
        star_thresholds: [25, 35, 45],
        background_theme: "forest",
        special_pieces: ["bomb", "rainbow", "line_clear"]
    },

    // Level 5 - Obstacles Challenge
    {
        level_id: 5,
        objective_type: "score",
        objective_value: 25,
        moves: 20,
        difficulty: "hard",
        star_thresholds: [20, 30, 40],
        background_theme: "desert",
        special_pieces: ["bomb", "rainbow", "line_clear"],
        obstacles: ["stone", "ice"], // عوائق في المستوى
        obstacle_positions: [[2,2], [4,4], [6,6]] // مواقع العوائق
    }
];

// متغير لتتبع المستوى الحالي الذي يلعبه اللاعب
global.current_level_index = 0; // يبدأ من المستوى الأول (فهرس 0)

// متغيرات إضافية لإدارة اللعبة
global.player_progress = {
    levels_completed: 0,
    total_stars: 0,
    highest_score: 0,
    level_stars: [] // مصفوفة لحفظ عدد النجوم لكل مستوى
};
