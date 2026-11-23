// Cutscene de abertura: imagens, video e musica sao arquivos incluidos.
start_us = current_time;
finished = false;
video_started = false;

scene_sprites = [
    sprite_add("intro/desmatamento.png", 1, false, false, 0, 0),
    sprite_add("intro/floresta_incendio.png", 1, false, false, 0, 0),
    sprite_add("intro/queimada_aerea.png", 1, false, false, 0, 0),
    sprite_add("intro/oceano_poluido.png", 1, false, false, 0, 0),
    sprite_add("intro/lago_poluido.png", 1, false, false, 0, 0)
];

music_stream = audio_create_stream("intro/musica_natureza_original.ogg");
music_instance = audio_play_sound(music_stream, 0, false);
audio_sound_gain(music_instance, 0.72, 0);

function finish_intro() {
    if (finished) return;
    finished = true;
    room_goto(Tutoras);
}
