if (video_get_status() != video_status_closed) video_close();

if (audio_exists(music_stream)) {
    audio_stop_sound(music_instance);
    audio_destroy_stream(music_stream);
}

for (var i = 0; i < array_length(scene_sprites); i++) {
    if (sprite_exists(scene_sprites[i])) sprite_delete(scene_sprites[i]);
}
