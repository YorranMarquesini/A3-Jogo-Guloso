timer++;

if (!instance_exists(boss)) {
    instance_destroy();
    exit;
}

switch (phase_name) {
    case "speech":
        boss.sprite_index = spr_cagliostro_talk;
        boss.image_speed = 0.22;
        if (timer >= speech_frames) {
            // O áudio não é interrompido: apenas termina a animação de fala.
            phase_name = "cigar";
            post_timer = 0;
            boss.sprite_index = spr_cagliostro_cigar_draw;
            boss.image_index = 0;
            boss.image_speed = 0.10;
        }
    break;

    case "cigar":
        post_timer++;
        if (boss.image_index >= sprite_get_number(spr_cagliostro_cigar_draw) - 1) {
            boss.image_index = sprite_get_number(spr_cagliostro_cigar_draw) - 1;
            boss.image_speed = 0;
            phase_name = "blackout";
            post_timer = 0;
        }
    break;

    case "blackout":
        post_timer++;
        black_alpha = clamp(post_timer / 24, 0, 1);
        if (post_timer >= 34 && !match_played) {
            match_played = true;
            audio_play_sound(snd_cagliostro_fosforo, 20, false);
        }
        if (post_timer >= 34) glow_alpha = clamp((post_timer - 34) / 14, 0, 1);
        if (post_timer >= 76) {
            phase_name = "reveal";
            post_timer = 0;
            boss.sprite_index = spr_cagliostro_idle;
            boss.image_index = 0;
            boss.image_speed = 0.12;
        }
    break;

    case "reveal":
        post_timer++;
        black_alpha = 1 - clamp(post_timer / 45, 0, 1);
        glow_alpha = max(0, 1 - post_timer / 25);
        if (post_timer >= 45) {
            black_alpha = 0;
            glow_alpha = 0;
            phase_name = "wait_audio";
        }
    break;

    case "wait_audio":
        // Mantém o Cagliostro revelado enquanto toca o restante do áudio misto.
        boss.sprite_index = spr_cagliostro_idle;
        boss.image_speed = 0.12;

        if (!audio_is_playing(speech_handle)) {
            // Continua o trecho musical embutido na fala ja durante o video.
            global.cagliostro_music = audio_play_sound(snd_cagliostro_tema, 2, true);
            audio_sound_set_track_position(global.cagliostro_music, music_resume_seconds);
            audio_sound_gain(global.cagliostro_music, 1, 0);

            phase_name = "video";
            video_requested = true;
            video_deadline_ms = current_time + 8000;
            video_open(working_directory + "boss2/cagliostro_intro.mp4");
        }
    break;

    case "video":
        // O limite evita prender a luta se o player de video nao responder.
        if (video_finished || video_get_status() == video_status_closed
        || current_time >= video_deadline_ms) {
            boss.state = "combat";
            boss.hittable = true;
            boss.attack_timer = 90;
            instance_destroy();
        }
    break;
}
