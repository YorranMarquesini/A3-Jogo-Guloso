if (invuln_timer > 0) invuln_timer--;
if (hit_flash_timer > 0) hit_flash_timer--;
if (smoke_break_cooldown > 0) smoke_break_cooldown--;
if (hat_break_cooldown > 0) hat_break_cooldown--;
if (hat_cut_flash_timer > 0) hat_cut_flash_timer--;
if (hat_disabled_timer > 0) {
    hat_disabled_timer--;

    // Fiapos e fragmentos saindo do chapéu enquanto ele está rasgado.
    if (hat_disabled_timer mod 10 == 0 && state != "cutscene" && state != "dying") {
        var _torn_y = y - (35 * abs(image_yscale));
        var _torn_particle = instance_create_depth(
            x + random_range(-85, 85),
            _torn_y + random_range(-18, 18),
            depth - 5,
            oHitParticle
        );
        _torn_particle.dir_x = random_range(-1.8, 1.8);
        _torn_particle.dir_y = random_range(-2.2, -0.6);
        _torn_particle.color = choose(c_dkgray, c_gray, c_silver, c_white);
        _torn_particle.radius = random_range(3, 7);
        _torn_particle.fade_speed = 0.045;
    }
}
image_blend = (hit_flash_timer > 0) ? c_red : c_white;

switch (state) {
    case "cutscene":
        // Sprites e ritmo são dirigidos por oCagliostroCutscene.
    break;

    case "combat":
        sprite_index = (phase == 2) ? spr_cagliostro_fase2_idle : spr_cagliostro_idle;
        image_speed = (phase == 2) ? 1 : 0.12;
        // Na fase 2 ele ataca um pouco mais rápido.
        attack_timer -= boss_speed_multiplier * ((phase == 2) ? 1.25 : 1);
        if (attack_timer <= 0) {
            var _next_attack;

            if (phase == 2) {
                // Alterna fogo e chuva de notas.
                _next_attack = (last_attack_kind == 2) ? 3 : 2;
            } else if (hat_disabled_timer > 0) {
                // Enquanto está rasgado, o chapéu fica na cabeça e não pode
                // ser lançado; o chefe usa somente a fumaça.
                _next_attack = 0;
            } else if (last_attack_kind == -1) {
                // Primeiro ataque: fumaça ou chapéu com chances iguais.
                _next_attack = irandom(1);
            } else if (attack_repeat_count >= max_attack_repeats) {
                // Nunca permite quatro ataques iguais seguidos.
                _next_attack = 1 - last_attack_kind;
            } else {
                // Pode repetir ou trocar livremente; repetição levemente favorecida
                // para evitar uma alternância previsível fumaça/chapéu.
                _next_attack = (random(1) < 0.55) ? last_attack_kind : 1 - last_attack_kind;
            }

            if (_next_attack == last_attack_kind) {
                attack_repeat_count++;
            } else {
                last_attack_kind = _next_attack;
                attack_repeat_count = 1;
            }

            attack_kind = _next_attack;
            attack_fired = false;
            attack_timer = 48;

            if (attack_kind == 0) {
                smoke_shots_remaining = irandom_range(3, 6);
                smoke_shot_timer = 20; // pequena antecipação antes da primeira fumaça
            }

            if (attack_kind == 2) {
                fire_shots_remaining = irandom_range(2, 4);
                fire_shot_fired = false;
                fire_hold_timer = 0;
                sprite_index = spr_cagliostro_atk1;
                image_index = 0;
            }

            if (attack_kind == 0) state = "smoke_attack";
            else if (attack_kind == 1) state = "hat_attack";
            else if (attack_kind == 2) state = "fire_attack";
            else {
                state = "money_attack";
                money_notes_left = irandom_range(4, 6);
                money_spawn_timer = 0;
            }
        }
    break;

    case "money_attack":
        image_speed = 1;
        if (money_notes_left == 0) {
            // Mesmo a ultima nota pode armar ao se aproximar do jogador.
            if (!instance_exists(oCagliostroMoney)) {
                state = "combat";
                attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
            }
            break;
        }
        var _armed = false;
        with (oCagliostroMoney) { if (explosive) _armed = true; }
        if (_armed) break;
        money_spawn_timer -= boss_speed_multiplier;
        if (money_spawn_timer > 0) break;
        money_spawn_timer = irandom_range(money_spawn_min, money_spawn_max);
        money_notes_left--;
        var _cam = view_camera[0];
        var _vx = camera_get_view_x(_cam);
        var _vy = camera_get_view_y(_cam);
        var _vw = camera_get_view_width(_cam);

        // De vez em quando uma nota cai mirando perto do jogador.
        var _mx = _vx + random_range(24, _vw - 24);
        if (instance_exists(oPlayer) && random(1) < 0.35) {
            _mx = clamp(oPlayer.x + random_range(-90, 90), _vx + 24, _vx + _vw - 24);
        }

        var _money = instance_create_depth(_mx, _vy - 32, depth - 3, oCagliostroMoney);
        _money.fall_speed *= boss_speed_multiplier;
    break;

    case "fire_attack":
        sprite_index = spr_cagliostro_atk1;
        image_speed = boss_speed_multiplier; // velocidade do próprio sprite

        if (!fire_shot_fired) {
            // Chegou no último quadro (boca aberta): cospe o fogo.
            if (image_index >= image_number - 1) {
                image_index = image_number - 1;
                image_speed = 0;
                fire_shot_fired = true;
                fire_hold_timer = fire_hold_time;
                fire_shots_remaining--;

                if (instance_exists(oPlayer)) {
                    var _fplayer = instance_find(oPlayer, 0);

                    // Boca aberta do spr_cagliostro_atk1 (lado esquerdo do rosto),
                    // acompanhando a escala gigante definida na room.
                    var _fire_x = x - (24 * image_xscale);
                    var _fire_y = y + (12 * abs(image_yscale));
                    var _aim_y = (_fplayer.bbox_top + _fplayer.bbox_bottom) * 0.5;

                    var _fire = instance_create_depth(_fire_x, _fire_y, depth - 1, oCagliostroFire);
                    _fire.direction = point_direction(_fire_x, _fire_y, _fplayer.x, _aim_y);
                    _fire.speed = fire_speed * boss_speed_multiplier;
                    _fire.image_angle = _fire.direction + _fire.sprite_angle_offset;

                    var _fire_sfx = audio_play_sound(snd_cagliostro_fosforo, 2, false);
                    audio_sound_gain(_fire_sfx, 0.55, 0);
                    audio_sound_pitch(_fire_sfx, random_range(0.85, 1.0));
                }
            }
        } else {
            image_index = image_number - 1;
            image_speed = 0;
            fire_hold_timer -= boss_speed_multiplier;

            if (fire_hold_timer <= 0) {
                if (fire_shots_remaining > 0) {
                    // Próxima cuspida: recomeça a animação.
                    fire_shot_fired = false;
                    image_index = 0;
                } else {
                    state = "combat";
                    sprite_index = spr_cagliostro_fase2_idle;
                    image_speed = 1;
                    image_index = 0;
                    attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
                }
            }
        }
    break;

    case "smoke_attack":
        sprite_index = (phase == 2) ? spr_cagliostro_fase2_idle : spr_cagliostro_idle;
        image_speed = 0.18;
        smoke_shot_timer -= boss_speed_multiplier;

        if (smoke_shots_remaining > 0 && smoke_shot_timer <= 0) {
            if (instance_exists(oPlayer)) {
                var _player = instance_find(oPlayer, 0);

                // Boca/charuto acompanhando a escala gigante definida na room.
                var _smoke_x = x - (20 * abs(image_xscale));
                var _smoke_y = y + (9 * abs(image_yscale));

                // Mira na superfície da plataforma sob o jogador. Se ele estiver
                // no ar, usa a primeira plataforma no caminho da queda.
                var _target_x = _player.x;
                var _target_y = _player.y;
                var _closest_platform_y = room_height + 1;

                for (var _i = 0; _i < instance_number(oGround); _i++) {
                    var _platform = instance_find(oGround, _i);
                    if (_target_x >= _platform.bbox_left - 12
                    &&  _target_x <= _platform.bbox_right + 12
                    &&  _platform.bbox_top >= _player.bbox_bottom - 4
                    &&  _platform.bbox_top < _closest_platform_y) {
                        _closest_platform_y = _platform.bbox_top;
                    }
                }

                if (_closest_platform_y <= room_height) {
                    // Passa rente à plataforma e ameaça os pés, sem cobrir o
                    // corpo inteiro do jogador com a hitbox.
                    _target_y = _closest_platform_y - 24;
                }

                var _ring = instance_create_depth(_smoke_x, _smoke_y, depth - 1, oCagliostroSmoke);
                _ring.direction = point_direction(_smoke_x, _smoke_y, _target_x, _target_y);
                _ring.speed = 6.5 * boss_speed_multiplier;
                var _smoke_sfx = audio_play_sound(snd_cagliostro_smoke_attack, 2, false);
                audio_sound_gain(_smoke_sfx, 0.48, 0);
                audio_sound_pitch(_smoke_sfx, random_range(0.92, 1.08));
            }

            smoke_shots_remaining--;
            smoke_shot_timer = (smoke_shots_remaining > 0)
                ? irandom_range(smoke_shot_interval_min, smoke_shot_interval_max)
                : smoke_end_lag;
        }

        if (smoke_shots_remaining <= 0 && smoke_shot_timer <= 0) {
            state = "combat";
            attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
        }
    break;

    case "hat_attack":
        sprite_index = spr_cagliostro_no_hat;
        image_speed = 0;
        attack_timer -= boss_speed_multiplier;

        if (!attack_fired && attack_timer <= 34) {
            attack_fired = true;
            var _hat_x = x;
            var _hat_y = y - (28 * abs(image_yscale));
            var _hat = instance_create_depth(_hat_x, _hat_y, depth - 2, oCagliostroHat);
            _hat.owner = id;
            _hat.move_speed *= boss_speed_multiplier;
            _hat.travel_timer = ceil(_hat.travel_timer / boss_speed_multiplier);
            var _hat_sfx = audio_play_sound(snd_cagliostro_hat_throw, 3, false);
            audio_sound_gain(_hat_sfx, 0.62, 0);
            audio_sound_pitch(_hat_sfx, random_range(0.96, 1.04));
        }

        if (attack_timer <= 0 && !instance_exists(oCagliostroHat)) {
            state = "combat";
            attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
        }
    break;

    case "transforming":
        if (!transform_started) {
            transform_started = true;
            sprite_index = spr_cagliostro_fase2_trasformation;
            image_index = 0;
            image_speed = 1; // usa a velocidade definida no próprio sprite
            hittable = false;
            smoke_shots_remaining = 0;

            // Limpa os ataques da fase 1 que ainda estão na tela.
            with (oCagliostroSmoke) instance_destroy();
            with (oCagliostroHat) instance_destroy();
        }

        // Partículas surgindo no ar ao redor e sendo puxadas para ele.
        if (image_index < image_number - 1) {
            var _reach = abs(sprite_width) * 0.5;
            repeat (3) {
                var _pa = random(360);
                var _pd = random_range(_reach * 0.9, _reach * 1.6);
                var _absorb = instance_create_depth(
                    x + lengthdir_x(_pd, _pa),
                    y + lengthdir_y(_pd, _pa),
                    depth - 5,
                    oCagliostroAbsorb
                );
                _absorb.target_x = x;
                _absorb.target_y = y;
            }
        }

        // Recarrega a barra de vida acompanhando a animação.
        var _transform_progress = clamp(image_index / max(1, image_number - 1), 0, 1);
        hp = max(hp, phase2_max_hp * _transform_progress);
        max_hp = phase2_max_hp;

        if (image_index >= image_number - 1) {
            // Segura um instante no último frame antes de voltar a lutar.
            image_index = image_number - 1;
            image_speed = 0;
            transform_timer--;
        }

        if (image_index >= image_number - 1 && transform_timer <= 0) {
            phase = 2;
            hp = phase2_max_hp;
            max_hp = phase2_max_hp;
            hittable = true;
            invuln_timer = 0;
            image_blend = c_white;
            state = "combat";
            attack_timer = 60;
            last_attack_kind = -1;
            attack_repeat_count = 0;
            sprite_index = spr_cagliostro_fase2_idle;
            image_speed = 1;
            image_index = 0;
        }
    break;

    case "dying":
        hittable = false;
        finale_time += delta_time / 1000000;
        switch (finale_stage) {
        case "hold":
            image_speed = 0;
            sprite_index = spr_cagliostro_fase2_explosion;
            image_index = 0;
            image_blend = c_white;
            with (oCagliostroFire) instance_destroy();
            with (oCagliostroMoney) instance_destroy();
            with (oCagliostroSmoke) instance_destroy();
            with (oCagliostroHat) instance_destroy();
            finale_stage = "charge";
            finale_time = 0;
        break;

        case "charge":
            var _frame = floor(finale_time * sprite_get_speed(sprite_index));
            image_index = min(_frame, image_number - 1);
            if (_frame >= image_number) {
                finale_qte_action = finale_actions[irandom(array_length(finale_actions) - 1)];
                finale_stage = "qte";
                finale_time = 0;
            }
        break;

        case "qte":
            var _pad = scr_gamepad_slot();
            var _right = controls_read(finale_qte_action, _pad);
            var _wrong = false;
            for (var i = 0; i < array_length(finale_actions); i++) {
                var _action = finale_actions[i];
                if (_action != finale_qte_action && controls_read(_action, _pad)) _wrong = true;
            }
            if (!_right && (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle))) _wrong = true;
            if (!_right && _pad >= 0) {
                for (var i = 0; i < array_length(global.controls_buttons); i++) {
                    if (gamepad_button_check_pressed(_pad, global.controls_buttons[i])) { _wrong = true; break; }
                }
            }
            if (_wrong || finale_time >= finale_qte_window) {
                if (instance_exists(oPlayer)) oPlayer.hp = 0;
                finale_stage = "defeat";
                finale_time = 0;
            } else if (_right) {
                finale_track = variable_global_exists("cagliostro_music") ? global.cagliostro_music : -1;
                if (!audio_is_playing(finale_track)) {
                    finale_track = audio_play_sound(snd_cagliostro_tema, 2, true);
                    global.cagliostro_music = finale_track;
                }
                finale_music_pos = audio_is_playing(finale_track) ? audio_sound_get_track_position(finale_track) : 0;
                var _idx = 0, _loop = 0, _len = audio_sound_length(snd_cagliostro_tema);
                while (_idx < array_length(finale_accents) && finale_accents[_idx] < finale_music_pos + 0.95) _idx++;
                for (var i = 0; i < array_length(finale_chart); i++) {
                    if (_idx == array_length(finale_accents)) { _idx = 0; _loop += _len; }
                    finale_cues[i] = _loop + finale_accents[_idx++] - finale_music_pos;
                }
                if (instance_exists(oPlayer)) {
                    repeat (48) {
                        var _spark = instance_create_depth(oPlayer.x, oPlayer.y - oPlayer.visual_float_height, depth - 20, oHitParticle);
                        var _angle = random(360), _speed = random_range(3, 15);
                        _spark.dir_x = lengthdir_x(_speed, _angle);
                        _spark.dir_y = lengthdir_y(_speed, _angle);
                        _spark.color = choose(c_white, c_aqua, c_lime);
                        _spark.radius = random_range(5, 15);
                    }
                }
                audio_sound_gain(audio_play_sound(snd_boss_explosion, 8, false), 0.45, 0);
                if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 16;
                finale_stage = "rhythm";
                finale_time = 0;
            }
        break;

        case "defeat":
            if (finale_time >= 0.9) scr_reiniciar_fase();
        break;

        case "rhythm":
            if (audio_is_playing(finale_track)) {
                var _now = audio_sound_get_track_position(finale_track);
                var _advance = _now - finale_music_pos;
                if (_advance < -1) _advance += audio_sound_length(snd_cagliostro_tema);
                finale_time += max(0, _advance) - delta_time / 1000000;
                finale_music_pos = _now;
            }
            clash_age += delta_time / 1000000;
            clash_front = lerp(clash_front, clamp(0.5 + (2 * finale_hits - finale_note) * 0.029, 0.15, 0.85), 0.12);
            var _total = array_length(finale_chart);
            while (finale_note < _total && finale_time > finale_cues[finale_note] + finale_hit_window) {
                finale_note++;
            }
            if (finale_note < _total) {
                var _pad = scr_gamepad_slot();
                var _pressed_lane = -1;
                for (var i = 0; i < array_length(finale_actions); i++) {
                    if (controls_read(finale_actions[i], _pad)) {
                        if (_pressed_lane != -1) { _pressed_lane = -2; break; }
                        _pressed_lane = i;
                    }
                }
                var _offset = finale_time - finale_cues[finale_note];
                if (_pressed_lane != -1 && _offset >= -0.24) {
                    if (_pressed_lane == finale_chart[finale_note] && abs(_offset) <= finale_hit_window) finale_hits++;
                    finale_note++;
                }
            }
            if (finale_note == _total) {
                finale_stage = "score";
                finale_time = 0;
            }
        break;

        case "score":
            clash_age += delta_time / 1000000;
            clash_front = lerp(clash_front, finale_hits * 4 > array_length(finale_chart) * 3 ? 1 : 0, 0.08);
            if (finale_time >= 1.3) {
                global.cagliostro_bad_ending = finale_hits * 4 <= array_length(finale_chart) * 3;
                if (audio_is_playing(finale_track)) audio_stop_sound(finale_track);
                if (global.cagliostro_bad_ending) {
                    room_goto(FinalCutscene);
                } else {
                    finale_stage = "victory_burst";
                }
            }
        break;

        case "victory_burst":
            final_explosion_timer = final_explosion_duration;
            image_alpha = 0;
            var _boom = audio_play_sound(snd_cagliostro_explosion, 8, false);
            audio_sound_gain(_boom, 0.82, 0);
            if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 28;
            repeat (150) {
                var _burst = instance_create_depth(x + random_range(-55, 55), y + random_range(-80, 55), depth - 20, oHitParticle);
                var _ba = random(360);
                var _bs = random_range(5, 19);
                _burst.dir_x = lengthdir_x(_bs, _ba);
                _burst.dir_y = lengthdir_y(_bs, _ba);
                _burst.color = choose(c_white, c_yellow, c_orange, c_red, make_color_rgb(76, 255, 151));
                _burst.radius = random_range(10, 30);
                _burst.fade_speed = random_range(0.018, 0.04);
            }
            finale_stage = "blast";
        break;
        case "blast":
            if (--final_explosion_timer <= 0) room_goto(FinalCutscene);
        break;

        }
    break;
}
