// داخل Create Event لـ obj_number
my_value = irandom_range(1, 9);
// داخل Create Event لـ obj_number
is_selected = false; // هل هذا الرقم محدد حاليًا؟
target_scale = 1; // الحجم الذي نريد الوصول إليه
current_scale = 1; // الحجم الحالي للكائن
image_blend = global.number_colors[my_value - 1]; // -1 لأن المصفوفات تبدأ من 0