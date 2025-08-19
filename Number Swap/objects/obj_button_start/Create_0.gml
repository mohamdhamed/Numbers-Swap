event_inherited(); // لتنفيذ الكود الموجود في الأب أولاً
action = function() {
    global.current_level_index = 0; // تأكد من أننا نبدأ من المستوى الأول
    room_goto(Room1);
};