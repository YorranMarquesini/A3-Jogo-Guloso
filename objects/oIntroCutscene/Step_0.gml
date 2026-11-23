var _elapsed = (current_time - start_ms) / 1000;

// Dispara cada fala uma unica vez e abre espaco na mixagem para a voz.
for (var _voice = 0; _voice < array_length(voice_streams); _voice++) {
    if (!voice_started[_voice] && _elapsed >= voice_start_times[_voice]) {
        voice_started[_voice] = true;
        voice_instances[_voice] = audio_play_sound(voice_streams[_voice], 20, false);
        audio_sound_gain(voice_instances[_voice], 1, 0);
        voice_duck_until = voice_end_times[_voice];
        voice_ducking = true;
        audio_sound_gain(music_instance, 0.18, 180);
        audio_sound_gain(effects_instance, 0.28, 180);
    }
}

// Depois da frase, devolve a intensidade adequada ao trecho atual.
if (voice_ducking && _elapsed >= voice_duck_until) {
    voice_ducking = false;
    var _video_mix = (_elapsed >= 14.5 && _elapsed < 44);
    audio_sound_gain(music_instance, _video_mix ? 0.14 : 0.78, 420);
    audio_sound_gain(effects_instance, _video_mix ? 0.46 : 0.88, 420);
}

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
    if (!voice_ducking) {
        audio_sound_gain(music_instance, 0.78, 900);
        audio_sound_gain(effects_instance, 0.88, 900);
    }
}

// Evita que o mesmo apertar usado no menu pule a cutscene imediatamente.
if (_elapsed > 1 && (keyboard_check_pressed(vk_space)
|| keyboard_check_pressed(vk_enter)
|| keyboard_check_pressed(vk_escape))) {
    finish_intro();
}

if (_elapsed >= 58.5) finish_intro();
