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

        // Espera a fala chegar no ponto em que o vídeo precisa começar para
        // terminar exatamente no drop (drop - duração do vídeo).
        var _speech_playing = audio_is_playing(speech_handle);
        var _speech_pos = _speech_playing ? audio_sound_get_track_position(speech_handle) : speech_total_seconds;
        var _video_start_at = music_embedded_offset + music_drop_seconds
                            - video_length_seconds - video_open_lead_seconds;

        if (!_speech_playing || _speech_pos >= _video_start_at) {
            phase_name = "video";
            video_requested = true;
            video_open_ms = current_time;
            video_deadline_ms = current_time + 8000;
            video_open(working_directory + "boss2/cagliostro_intro.mp4");
        }
    break;

    case "video":
        // 1) Assim que o vídeo começa de fato, o tema entra no mesmo ponto da
        //    música embutida na fala, no mesmo volume baixo dela.
        if (!theme_started
        && (video_get_status() == video_status_playing || current_time >= video_open_ms + 400)) {
            theme_started = true;

            var _video_pos = (video_get_status() == video_status_playing) ? video_get_position() / 1000 : 0;
            theme_start_pos = clamp(music_drop_seconds - video_length_seconds + _video_pos, 0, music_drop_seconds);

            global.cagliostro_music = audio_play_sound(snd_cagliostro_tema, 2, true);
            audio_sound_set_track_position(global.cagliostro_music, theme_start_pos);
            audio_sound_gain(global.cagliostro_music, embedded_music_gain, 0);
        }

        if (theme_started) {
            var _theme_pos = audio_sound_get_track_position(global.cagliostro_music);

            // 2) Crossfade: a fala some rápido e o tema cresce até o drop.
            //    O crescimento é em escala de volume percebido (dB), então soa
            //    como um "swell" contínuo, sem pular no final.
            speech_fade_gain = max(0, speech_fade_gain - 1 / (0.25 * game_get_speed(gamespeed_fps)));
            if (audio_is_playing(speech_handle)) {
                audio_sound_gain(speech_handle, speech_fade_gain, 0);
                if (speech_fade_gain <= 0) audio_stop_sound(speech_handle);
            }

            var _swell = clamp((_theme_pos - theme_start_pos) / max(0.01, music_drop_seconds - theme_start_pos), 0, 1);
            var _gain = embedded_music_gain * power(1 / embedded_music_gain, _swell);
            audio_sound_gain(global.cagliostro_music, _gain, 0);

            // 3) No drop a luta começa.
            if (_theme_pos >= music_drop_seconds - 0.01) {
                audio_sound_gain(global.cagliostro_music, 1, 0);
                if (audio_is_playing(speech_handle)) audio_stop_sound(speech_handle);
                if (video_get_status() != video_status_closed) video_close();
                if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 10;

                boss.state = "combat";
                boss.hittable = true;
                boss.attack_timer = 90;
                instance_destroy();
                exit;
            }
        }

        // O limite evita prender a luta se o player de vídeo não responder.
        if (current_time >= video_deadline_ms) {
            if (!theme_started) {
                global.cagliostro_music = audio_play_sound(snd_cagliostro_tema, 2, true);
                audio_sound_set_track_position(global.cagliostro_music, music_drop_seconds);
            }
            audio_sound_gain(global.cagliostro_music, 1, 0);
            if (audio_is_playing(speech_handle)) audio_stop_sound(speech_handle);
            if (video_get_status() != video_status_closed) video_close();
            boss.state = "combat";
            boss.hittable = true;
            boss.attack_timer = 90;
            instance_destroy();
        }
    break;
}
