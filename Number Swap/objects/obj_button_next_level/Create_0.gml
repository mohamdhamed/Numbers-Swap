event_inherited();
button_text = "Next Level";

action = function() {
    // حاول التقدم للمستوى التالي
    if (advance_to_next_level()) {
        room_restart(); // ابدأ المستوى التالي
    } else {
        // لقد أنهيت كل المستويات!
        room_goto(Room_Start); // يمكنك إنشاء شاشة "تهانينا" هنا لاحقًا
    }
};