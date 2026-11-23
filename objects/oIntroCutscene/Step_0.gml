var _elapsed = (current_time - start_ms) / 1000;

// Abre o video pouco antes da hora de exibi-lo para evitar um quadro vazio.
if (!video_started && _elapsed >= 14.5) {
    video_started = true;
    video_open(intro_path + "nave_destruicao_pixel.mp4");
    video_set_volume(0);
}

// Evita que o mesmo apertar usado no menu pule a cutscene imediatamente.
if (_elapsed > 1 && (keyboard_check_pressed(vk_space)
|| keyboard_check_pressed(vk_enter)
|| keyboard_check_pressed(vk_escape))) {
    finish_intro();
}

if (_elapsed >= 57) finish_intro();
