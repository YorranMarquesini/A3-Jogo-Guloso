start_ms = current_time;
depth = -12000;
menu_revealing = false;
video_started = false;
video_snapshot = -1;
startup_path = working_directory + "startup/";
logo_sprite = sprite_add(startup_path + "sigma_room_mark.png", 1, false, false, 0, 0);
if (sprite_exists(logo_sprite)) {
    sprite_set_offset(logo_sprite, sprite_get_width(logo_sprite) * 0.5, sprite_get_height(logo_sprite) * 0.5);
}
logo_sound = audio_play_sound(snd_sigma_logo, 4, false);
audio_sound_gain(logo_sound, 0.72, 0);

shh_instance = -1;
shh_started = false;

