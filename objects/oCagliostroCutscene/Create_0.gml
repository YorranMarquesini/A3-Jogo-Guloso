speech_handle = noone;
video_requested = false;
video_finished = false;
video_deadline_ms = 0;

// Retry da arena: pula a introducao e recomeca o tema desde 0:00.
if (variable_global_exists("boss_retry_no_cutscene") && global.boss_retry_no_cutscene) {
    var _retry_boss = instance_find(oCagliostro, 0);

    if (variable_global_exists("cagliostro_music")
    &&  global.cagliostro_music != noone
    &&  audio_is_playing(global.cagliostro_music)) {
        audio_stop_sound(global.cagliostro_music);
    }

    global.cagliostro_music = audio_play_sound(snd_cagliostro_tema, 2, true);
    audio_sound_set_track_position(global.cagliostro_music, 0);
    audio_sound_gain(global.cagliostro_music, 1, 0);

    if (instance_exists(_retry_boss)) {
        _retry_boss.state = "combat";
        _retry_boss.hittable = true;
        _retry_boss.sprite_index = spr_cagliostro_idle;
        _retry_boss.image_speed = 0.12;
        _retry_boss.attack_timer = 90;
    }

    global.boss_retry_no_cutscene = false;
    instance_destroy();
    exit;
}

timer = 0;
depth = -12000;
phase_name = "speech";
boss = instance_find(oCagliostro, 0);
speech_handle = audio_play_sound(snd_cagliostro_fala, 10, false);
// A boca para em 30s, mas o arquivo continua: ele já contém o início da música.
speech_frames = 30 * game_get_speed(gamespeed_fps);
speech_total_seconds = audio_sound_length(snd_cagliostro_fala);
music_embedded_start_seconds = 32;
// Quando o áudio misto acabar, a faixa separada continua de onde ele parou.
music_resume_seconds = max(0, speech_total_seconds - music_embedded_start_seconds);
match_played = false;
black_alpha = 0;
glow_alpha = 0;
post_timer = 0;
global.cagliostro_music = noone;

if (instance_exists(boss)) {
    boss.state = "cutscene";
    boss.hittable = false;
    boss.sprite_index = spr_cagliostro_talk;
    boss.image_speed = 0.22;
}
