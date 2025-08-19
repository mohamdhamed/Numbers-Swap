// Clean Up Event for obj_game_controller

// هذا الكود يتم تنفيذه مرة واحدة فقط عند تدمير الكائن
// للتأكد من تحرير الذاكرة التي تم حجزها

show_debug_message("Game Controller Clean Up: Destroying data structures.");

// تدمير الشبكة المنطقية للعبة
if (ds_exists(game_grid, ds_type_grid)) {
    ds_grid_destroy(game_grid);
}

// تدمير قائمة الأرقام المحددة
if (ds_exists(selection_list, ds_type_list)) {
    ds_list_destroy(selection_list);
}
if (ds_exists(colors_cleared, ds_type_map)) {
    ds_map_destroy(colors_cleared);
}