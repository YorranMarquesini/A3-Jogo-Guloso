if (speech_handle != noone && audio_is_playing(speech_handle)) audio_stop_sound(speech_handle);
if (video_requested && video_get_status() != video_status_closed) video_close();
