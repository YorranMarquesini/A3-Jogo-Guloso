io_clear();

if (voz_atual != noone && audio_is_playing(voz_atual)) {
    audio_stop_sound(voz_atual);
}	