var _elapsed = (current_time - start_ms) / 1000;

// Abre o video pouco antes da hora de exibi-lo para evitar um quadro vazio.
if (!video_started && _elapsed >= 14.5) {
    video_started = true;
    video_open(intro_path + "nave_destruicao_pixel.mp4");
    video_set_volume(0.82);
    audio_sound_gain(music_instance, 0.14, 700);
    audio_sound_gain(effects_instance, 0.46, 700);
}

// Abre espaco para o audio original do filme e restaura a mixagem ao final.
if (!video_mix_restored && _elapsed >= 44) {
    video_mix_restored = true;
    audio_sound_gain(music_instance, 0.78, 900);
    audio_sound_gain(effects_instance, 0.88, 900);
}

// Evita que o mesmo apertar usado no menu pule a cutscene imediatamente.
if (_elapsed > 1 && (keyboard_check_pressed(vk_space)
|| keyboard_check_pressed(vk_enter)
|| keyboard_check_pressed(vk_escape))) {
    finish_intro();
}

if (_elapsed >= 58.5) finish_intro();
