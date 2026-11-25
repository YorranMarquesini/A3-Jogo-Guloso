var _elapsed = (current_time - start_ms) / 1000;

// Os primeiros nove segundos usam recortes reais de desmatamento. O arquivo
// foi exportado sem audio para preservar a musica, os efeitos e a narracao.
if (!destruction_video_started && _elapsed >= 0.05) {
    destruction_video_started = true;
    video_open(intro_path + "desmatamento_clipes_pixel.mp4");
    video_set_volume(0);
}

if (!destruction_video_closed && _elapsed >= 9.15) {
    destruction_video_closed = true;
    if (video_get_status() != video_status_closed) video_close();
}

// Dispara cada fala uma unica vez e abre espaco na mixagem para a voz.
for (var _voice = 0; _voice < array_length(voice_sounds); _voice++) {
    if (!voice_started[_voice] && _elapsed >= voice_start_times[_voice]) {
        voice_started[_voice] = true;
        voice_instances[_voice] = audio_play_sound(voice_sounds[_voice], 20, false);
        audio_sound_gain(voice_instances[_voice], 1, 0);
        voice_duck_until = voice_end_times[_voice];
        voice_ducking = true;
        audio_sound_gain(music_instance, 0.12, 180);
        audio_sound_gain(effects_instance, 0.14, 180);
    }
}

// Depois da frase, devolve a intensidade adequada ao trecho atual.
if (voice_ducking && _elapsed >= voice_duck_until) {
    voice_ducking = false;
    var _video_mix = (_elapsed >= 14.5 && _elapsed < 44);
    audio_sound_gain(music_instance, _video_mix ? 0.10 : 0.62, 420);
    audio_sound_gain(effects_instance, _video_mix ? 0.26 : 0.48, 420);
}

// Abre o video pouco antes da hora de exibi-lo para evitar um quadro vazio.
if (!video_started && _elapsed >= 14.5) {
    video_started = true;
    if (video_get_status() != video_status_closed) video_close();
    video_open(intro_path + "nave_destruicao_pixel.mp4");
    video_set_volume(0.62);
    audio_sound_gain(music_instance, 0.10, 700);
    audio_sound_gain(effects_instance, 0.26, 700);
}

// Abre espaco para o audio original do filme e restaura a mixagem ao final.
if (!video_mix_restored && _elapsed >= 44) {
    video_mix_restored = true;
    if (!voice_ducking) {
        audio_sound_gain(music_instance, 0.62, 900);
        audio_sound_gain(effects_instance, 0.48, 900);
    }
}

// Evita que o mesmo apertar usado no menu pule a cutscene imediatamente.
if (_elapsed > 1 && (keyboard_check_pressed(vk_space)
|| keyboard_check_pressed(vk_enter)
|| keyboard_check_pressed(vk_escape))) {
    finish_intro();
}

if (_elapsed >= 58.5) finish_intro();
