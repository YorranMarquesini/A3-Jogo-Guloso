var _elapsed = (current_time - start_ms) / 1000;
var _skip = _elapsed > 1 && (keyboard_check_pressed(vk_escape)
    || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space));

if (room != rm_menu) {
    if (_skip) {
        room_goto(rm_menu);
        instance_destroy();
    } else if (_elapsed >= 3.55) {
        persistent = true;
        room_goto(rm_menu);
    }
    exit;
}

if (_skip) {
    // Libera o menu no proximo Step, depois do comando de pular.
    start_ms = current_time - 8200;
    exit;
}
if (_elapsed >= 8.15) {
    instance_destroy();
    exit;
}

menu_revealing = _elapsed >= 6.15;
if (!video_started) {
    video_started = true;
    video_open(startup_path + "sigma_intro_video.mp4");
    video_set_volume(0.82);
}

if (!shh_started && _elapsed >= 5.58) {
    shh_started = true;
    shh_instance = audio_play_sound(snd_sigma_shh, 12, false);
    audio_sound_gain(shh_instance, 0.90, 0);
}
