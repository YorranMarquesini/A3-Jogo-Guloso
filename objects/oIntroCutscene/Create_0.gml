// Cutscene de abertura: imagens, video e musica sao arquivos incluidos.
start_ms = current_time;
finished = false;
video_started = false;
video_mix_restored = false;

intro_path = working_directory + "intro/";
scene_sprites = [
    sprite_add(intro_path + "desmatamento.png", 1, false, false, 0, 0),
    sprite_add(intro_path + "floresta_incendio.png", 1, false, false, 0, 0),
    sprite_add(intro_path + "queimada_aerea.png", 1, false, false, 0, 0),
    sprite_add(intro_path + "oceano_poluido.png", 1, false, false, 0, 0),
    sprite_add(intro_path + "lago_poluido.png", 1, false, false, 0, 0)
];

scenes_ready = true;
for (var i = 0; i < array_length(scene_sprites); i++) {
    if (!sprite_exists(scene_sprites[i])) scenes_ready = false;
}

music_stream = audio_create_stream(intro_path + "musica_natureza_original.ogg");
music_instance = audio_play_sound(music_stream, 0, false);
audio_sound_gain(music_instance, 0.62, 0);

effects_stream = audio_create_stream(intro_path + "efeitos_cinematicos.ogg");
effects_instance = audio_play_sound(effects_stream, 1, false);
audio_sound_gain(effects_instance, 0.48, 0);

// Dublagem das quatro cartelas, na mesma ordem em que aparecem na tela.
voice_sounds = [
    snd_intro_narracao_01,
    snd_intro_narracao_02,
    snd_intro_narracao_03,
    snd_intro_narracao_04
];
voice_instances = array_create(4, -1);
voice_started = array_create(4, false);
voice_start_times = [1.15, 9.3, 44.6, 51.7];
voice_end_times = [3.35, 11.95, 47.75, 55.55];
voice_duck_until = -1;
voice_ducking = false;

function finish_intro() {
    if (finished) return;
    finished = true;
    room_goto(Tutoras);
}
