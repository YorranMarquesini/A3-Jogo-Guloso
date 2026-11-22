timer = 0;
phase_name = "speech";
boss = instance_find(oCagliostro, 0);
speech_handle = audio_play_sound(snd_cagliostro_fala, 10, false);
// A boca para em 30s, mas o arquivo continua: ele já contém o início da música.
speech_frames = 30 * game_get_speed(gamespeed_fps);
speech_total_seconds = audio_sound_length(snd_cagliostro_fala);
music_embedded_start_seconds = 32;
// Quando o áudio misto acabar, a faixa separada continua de onde ele parou.
music_resume_seconds = max(0, speech_total_seconds - music_embedded_start_seconds);
music_started = false;
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
