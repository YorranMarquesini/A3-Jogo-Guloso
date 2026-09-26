switch (state) {

    case "absorbing_pollution":
        sprite_index = boss1_idle_spr;
        hittable = false;

        // Captura o valor real só no 1º frame (garante que oPollutionManager já rodou)
        if (absorb_timer == absorb_duration) {
            pollution_absorbed_pct = variable_global_exists("pollution_pct") ? global.pollution_pct : 0;
        }

        absorb_timer -= 1;

        // Drena a barra global suavemente até 0
        if (variable_global_exists("pollution_pct")) {
            global.pollution_pct = lerp(global.pollution_pct, 0, 0.08);
            if (global.pollution_pct < 0.5) global.pollution_pct = 0;
        }

        // Brilho pulsante enquanto absorve
        var _pulse = 0.5 + 0.5 * sin(current_time / 60);
        image_blend = merge_color(c_white, c_lime, _pulse);

        // Partículas "sugadas" em direção ao boss
        if (absorb_timer mod 6 == 0) {
            var _px = x + random_range(-sprite_width / 2, sprite_width / 2);
            var _py = y + random_range(0, 40);
            var _p = instance_create_depth(_px, _py, depth - 10, oHitParticle);
            _p.dir_x = (x - _px) * 0.05;
            _p.dir_y = -random_range(2, 4);
            _p.color = c_lime;
            _p.radius = random_range(4, 8);
            _p.fade_speed = 0.03;
        }

        if (absorb_timer <= 0 || (variable_global_exists("pollution_pct") && global.pollution_pct <= 0)) {
            global.pollution_pct = 0;
            boss_speed_mult = scr_get_pollution_speed_bonus(pollution_absorbed_pct);

            image_blend = c_white;
            hittable = true;
            state = "idle";
            attack_cooldown = attack_cooldown_max / boss_speed_mult;
        }
    break;

    case "idle":
        sprite_index = boss1_idle_spr;
        attack_cooldown -= 1;

        if (attack_cooldown <= 0) {
            state = "attack_windup";
            attack_windup = attack_windup_time;
        }
    break;

    case "attack_windup":
        if (sprite_index != boss1_attack_spr) {
            sprite_index = boss1_attack_spr;
            image_index = 0;
            image_speed = boss_speed_mult;
        }

        // Pisca em amarelo/vermelho durante o windup como aviso
        image_blend = (hit_flash_timer > 0) ? c_white :
                      (sin(current_time / 60) > 0 ? c_yellow : c_white);

        if (image_index >= image_number - 1) {
            var _spawn_x = x;
            var _spawn_y = y - 20;

            audio_play_sound(snd_boss1_attack, 1, false);
            var _p = instance_create_depth(_spawn_x, _spawn_y, depth, oBossProjectile);

            repeat (5) {
                var _fx = instance_create_depth(_spawn_x, _spawn_y, depth, oHitParticle);
                var _ang = random(360);
                _fx.dir_x = lengthdir_x(1, _ang);
                _fx.dir_y = lengthdir_y(1, _ang);
                _fx.color = c_aqua;
            }

            state = "idle";
            attack_cooldown = attack_cooldown_max / boss_speed_mult;
            image_blend = c_white;
        }
    break;

    case "transforming":
        if (sprite_index != boss1_fase2_transformation_spr) {
            sprite_index = boss1_fase2_transformation_spr;
            image_index = 0;
            image_speed = 1;
            hittable = false;

            repeat (20) {
                var _tp = instance_create_depth(x, y - 60, depth, oHitParticle);
                var _ang = random(360);
                var _spd_mult = random_range(1, 2);
                _tp.dir_x = lengthdir_x(1, _ang) * _spd_mult;
                _tp.dir_y = lengthdir_y(1, _ang) * _spd_mult;
                _tp.color = c_purple;
                _tp.radius = random_range(10, 10);
                _tp.fade_speed = 0.03;
            }
        }

        transform_timer -= 1;

        image_blend = merge_color(c_white, c_purple, abs(sin(current_time / 100)));

        if (image_index >= image_number - 1 && transform_timer <= 0) {
            phase = 2;
            hp = phase2_max_hp;
            state = "idle2";
            hittable = true;
            image_blend = c_white;
        }
    break;

    case "attack_water_windup":
        if (sprite_index != boss1fase2_attack1_spr) {
            sprite_index = boss1fase2_attack1_spr;
            image_index = 0;
            image_speed = boss_speed_mult;
            water_spawned = false;
        }

        if (!water_spawned && image_index >= image_number - 2) {
            water_spawned = true;

            var _dir = point_direction(x, y, oPlayer.x, oPlayer.y);

            var _spawn_x = x + water_spawn_offset_x;
            var _spawn_y = y + water_spawn_offset_y;

            water_projectile = instance_create_depth(_spawn_x, _spawn_y, depth, oBossWaterProjectile);
            water_projectile.dir = _dir + 180;
            water_projectile.image_xscale = 0.1;
        }

        if (image_index >= image_number - 1) {
            image_index = image_number - 1;
            image_speed = 0;
            state = "attack_water_active";
        }
    break;

    case "attack_water_active":
        image_index = image_number - 1;
        image_speed = 0;

        if (!instance_exists(water_projectile)) {
            state = "idle2";
            phase2_attack_cooldown = phase2_attack_cooldown_max / boss_speed_mult;
        }
    break;

    case "attack_eyedrop_windup":
        if (sprite_index != boss1fase2_attack2_spr) {
            sprite_index = boss1fase2_attack2_spr;
            image_index = 0;
            image_speed = boss_speed_mult;
        }

        if (image_index >= image_number - 1) {
            state = "attack_eyedrop_warning";
            warning_started = false;
        }
    break;

    case "attack_eyedrop_warning":
        sprite_index = boss1_fase2_idle2_spr;

        if (!warning_started) {
            warning_started = true;
            eyedrop_warning_timer = eyedrop_warning_time;

            var _platforms = ds_list_create();
            with (oGround) {
                ds_list_add(_platforms, id);
            }

            var _targets_count = min(3, ds_list_size(_platforms));
            for (var _i = 0; _i < _targets_count; _i++) {
                var _idx = irandom(ds_list_size(_platforms) - 1);
                var _plat = _platforms[| _idx];
                ds_list_delete(_platforms, _idx);

                var _plat_center_x = (_plat.bbox_left + _plat.bbox_right) / 2;
                var _w = instance_create_depth(_plat_center_x, _plat.y, depth, oEyedropWarning);
                _w.target_plat = _plat;
            }

            ds_list_destroy(_platforms);
        }

        eyedrop_warning_timer -= 1;
        if (eyedrop_warning_timer <= 0) {
            state = "idle2";
            phase2_attack_cooldown = phase2_attack_cooldown_max / boss_speed_mult;
            warning_started = false;
        }
    break;

    case "idle2":
        sprite_index = boss1_fase2_idle_spr;

        phase2_attack_cooldown -= 1;
        if (phase2_attack_cooldown <= 0) {
            state = (irandom(1) == 0) ? "attack_water_windup" : "attack_eyedrop_windup";
        }
    break;

    case "dying":
        image_speed = 0;

        death_timer -= 1;

        image_blend = (death_timer mod 6 < 3) ? c_white : c_red;

        if (death_timer mod 6 == 0) {
            repeat (15) {
                var _ex = random_range(-sprite_width / 2, sprite_width / 2);
                var _ey = random_range(-sprite_height / 2, sprite_height / 2);
                var _p = instance_create_depth(x + _ex, y + _ey, depth - 10, oHitParticle);
                var _ang = random(360);
                var _spd = random_range(2, 6);
                _p.dir_x = lengthdir_x(1, _ang) * _spd;
                _p.dir_y = lengthdir_y(1, _ang) * _spd;
                _p.color = choose(c_yellow, c_orange, c_red, c_white);
                _p.radius = random_range(6, 16);
                _p.fade_speed = 0.04;
            }

            if (instance_exists(oCameraController_boss)) {
                oCameraController_boss.shake_amount = 6;
            }
        }

        if (death_timer <= 0) {
            repeat (60) {
                var _fx = random_range(-sprite_width / 2, sprite_width / 2);
                var _fy = random_range(-sprite_height / 2, sprite_height / 2);
                var _p2 = instance_create_depth(x + _fx, y + _fy, depth - 10, oHitParticle);
                var _ang2 = random(360);
                var _spd2 = random_range(4, 10);
                _p2.dir_x = lengthdir_x(1, _ang2) * _spd2;
                _p2.dir_y = lengthdir_y(1, _ang2) * _spd2;
                _p2.color = choose(c_yellow, c_orange, c_white, c_red, c_purple);
                _p2.radius = random_range(10, 24);
                _p2.fade_speed = 0.025;
            }

            if (instance_exists(oCameraController_boss)) {
                oCameraController_boss.shake_amount = 16;
            }

            // TODO: acionar aqui o que acontece depois (abrir porta, dar item, trocar de room, etc)
            instance_destroy();
        }
    break;
}

// --- INVENCIBILIDADE E FLASH DE DANO ---
// Só aplica esse flash genérico em states que não controlam a própria cor
// (absorbing_pollution, transforming, dying e attack_windup já calculam o image_blend deles mesmos)
if (invuln_timer > 0) {
    invuln_timer -= 1;
}
if (hit_flash_timer > 0) {
    hit_flash_timer -= 1;
}

if (state != "absorbing_pollution" && state != "transforming" && state != "dying" && state != "attack_windup") {
    image_blend = (hit_flash_timer > 0) ? c_white : c_red;
    if (invuln_timer <= 0) {
        image_blend = c_white;
    }
}