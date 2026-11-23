if (video_get_status() != video_status_closed) video_close();

if (audio_exists(music_stream)) {
    audio_stop_sound(music_instance);
    audio_destroy_stream(music_stream);
}

if (audio_exists(effects_stream)) {
    audio_stop_sound(effects_instance);
    audio_destroy_stream(effects_stream);
}

for (var v = 0; v < array_length(voice_streams); v++) {
    if (voice_instances[v] != -1 && audio_is_playing(voice_instances[v])) {
        audio_stop_sound(voice_instances[v]);
    }
    if (audio_exists(voice_streams[v])) audio_destroy_stream(voice_streams[v]);
}

for (var i = 0; i < array_length(scene_sprites); i++) {
    if (sprite_exists(scene_sprites[i])) sprite_delete(scene_sprites[i]);
}
