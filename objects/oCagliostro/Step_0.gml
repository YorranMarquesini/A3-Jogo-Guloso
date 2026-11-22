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
        sprite_index = spr_cagliostro_idle;
        image_speed = 0.12;
        attack_timer -= boss_speed_multiplier;
        if (attack_timer <= 0) {
            var _next_attack;

            if (hat_disabled_timer > 0) {
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

            state = (attack_kind == 0) ? "smoke_attack" : "hat_attack";
        }
    break;

    case "smoke_attack":
        sprite_index = spr_cagliostro_idle;
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
        }

        if (attack_timer <= 0 && !instance_exists(oCagliostroHat)) {
            state = "combat";
            attack_timer = irandom_range(attack_cooldown_min, attack_cooldown_max);
        }
    break;

    case "dying":
        hittable = false;
        image_speed = 0;
        death_timer--;
        image_blend = (death_timer mod 8 < 4) ? c_white : c_red;

        if (death_timer mod 8 == 0) {
            repeat (12) {
                var _p = instance_create_depth(x + random_range(-100, 100), y + random_range(-130, 70), depth - 10, oHitParticle);
                var _a = random(360);
                var _s = random_range(2, 7);
                _p.dir_x = lengthdir_x(_s, _a);
                _p.dir_y = lengthdir_y(_s, _a);
                _p.color = choose(c_red, c_orange, c_white, c_gray);
                _p.radius = random_range(8, 18);
            }
        }

        if (death_timer <= 0) {
            if (variable_global_exists("cagliostro_music")) {
                audio_sound_gain(global.cagliostro_music, 0, 900);
            }
            instance_destroy();
        }
    break;
}
