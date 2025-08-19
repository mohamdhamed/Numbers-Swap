// --- إعدادات الشبكة ---
// هذه متغيرات يمكننا تغييرها بسهولة لاحقًا
grid_width = 10;     // عدد الأعمدة
grid_height = 10;   // عدد الصفوف
cell_size = 68;     // حجم الخلية بالبكسل (عرض وارتفاع)

// --- تحميل بيانات المستوى الحالي ---
var _current_level = get_current_level();
// -- التحقق من وجود المستوى --
if (_current_level == undefined) {
    show_debug_message("خطأ: لا يمكن العثور على المستوى الحالي!");
    room_goto(Room_Start); // العودة للقائمة الرئيسية إذا لم يتم العثور على المستوى
    return; // إيقاف تنفيذ باقي الكود
}

// متغيرات لتتبع حالة اللعبة بناءً على المستوى
game_objective_type = _current_level.objective_type;
game_objective_value = _current_level.objective_value;
moves_left = _current_level.moves;
current_score = 0; // نبدأ دائماً من صفر
// مصفوفة لتخزين ألوان الأرقام من 1 إلى 9
global.number_colors = [
    c_aqua,       // لون الرقم 1
    c_lime,       // لون الرقم 2
    c_yellow,     // لون الرقم 3
    c_orange,     // لون الرقم 4
    make_color_rgb(255, 128, 0), // برتقالي أغمق للرقم 5
    c_red,        // لون الرقم 6
    c_fuchsia,    // لون الرقم 7
    c_lime,     // لون الرقم 8
    make_color_rgb(102, 0, 204)  // بنفسجي غامق للرقم 9
];
// حساب الموضع الأولي للشبكة لوضعها في منتصف الشاشة
// room_width هو عرض الغرفة الكلي
start_x = (room_width / 2) - (grid_width * cell_size / 2);
start_y = 300; // يمكن تعديل هذه القيمة لإنزال الشبكة أو رفعها

// --- إنشاء الشبكة المنطقية ---
// ds_grid هو مثل جدول لتخزين بياناتنا
game_grid = ds_grid_create(grid_width, grid_height);

// --- حلقة لإنشاء كائنات الأرقام ---
// هذه الحلقة ستمر على كل عمود
for (var i = 0; i < grid_width; i++) {
    // وهذه الحلقة ستمر على كل صف داخل العمود الحالي
    for (var j = 0; j < grid_height; j++) {

        // حساب الموضع الدقيق على الشاشة لهذا الرقم
        var _pos_x = start_x + (i * cell_size) + (cell_size / 2);
        var _pos_y = start_y + (j * cell_size) + (cell_size / 2);

        // إنشاء نسخة جديدة من obj_number في الموضع المحسوب
        var _new_number = instance_create_layer(_pos_x, _pos_y, "Instances", obj_number);

        // الآن، سنقوم بتخزين بعض المعلومات المفيدة داخل الكائن الجديد
        // نستخدم النقطة (.) للوصول للمتغيرات داخل _new_number
        _new_number.grid_x = i; // نخبره بموقعه في العمود
        _new_number.grid_y = j; // نخبره بموقعه في الصف

        // نخزن "هوية" الكائن الجديد في جدولنا المنطقي
        game_grid[# i, j] = _new_number.id;
	
	
    }
}


// --- متغيرات تتبع اختيار اللاعب ---

// هذا المتغير يعمل كمفتاح تشغيل/إيقاف. يخبرنا إذا كان اللاعب يضغط ويسحب حاليًا
is_selecting = false;

// هذه "القائمة" الديناميكية ستكون مثل سلة التسوق. سنضع فيها كل الأرقام التي يختارها اللاعب
selection_list = ds_list_create();

// متغيرات لتخزين اتجاه السلسلة المقفول
// 0 يعني لا يوجد اتجاه محدد بعد
selection_dx = 0; // اتجاه الحركة على محور X (-1 يسار, 0 لا تغيير, 1 يمين)
selection_dy = 0; // اتجاه الحركة على محور Y (-1 فوق, 0 لا تغيير, 1 تحت)

current_sum=0;

shake_intensity = 0;
shake_time = 0;
game_state = "playing"; // الحالات الممكنة: "playing", "won", "lost"
// ... بعد كل الكود الموجود بالفعل ...

// متغير جديد لتتبع عدد القطع المزالة من كل لون
colors_cleared = ds_map_create();