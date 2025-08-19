// Step Event for obj_destruction_effect
scale -= 0.08;   // قلل الحجم تدريجياً
alpha -= 0.08;   // قلل الشفافية تدريجياً

if (alpha <= 0) {
    instance_destroy(); // دمر الكائن عندما يصبح شفافاً تماماً
}