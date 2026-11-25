switch (state) {

    case "idle":
        sprite_index = boss1_idle_spr;
        attack_cooldown -= boss_speed_multiplier;

        if (attack_cooldown <= 0) {
            state = "attack_windup";
            attack_windup = attack_windup_time;
        }
    break;

    case "attack_windup":
    if (sprite_index != boss1_attack_spr) {
        sprite_index = boss1_attack_spr;
        image_index = 0;
        image_speed = boss_speed_multiplier;
    }

    // Pisca em amarelo/vermelho durante o windup como aviso
    image_blend = (hit_flash_timer > 0) ? c_white :
                  (sin(current_time / 60) > 0 ? c_yellow : c_white);

    if (image_index >= image_number) {
        var _spawn_x = x;
        var _spawn_y = y - 20;
		
		if (boss_attack_sound_handle != noone && audio_is_playing(boss_attack_sound_handle)) {
			audio_stop_sound(boss_attack_sound_handle);
		}
		boss_attack_sound_handle = audio_play_sound(snd_boss1_attack, 2, false);
		audio_sound_gain(boss_attack_sound_handle, 0.28, 0);
        var _p = instance_create_layer(_spawn_x, _spawn_y, layer, oBossProjectile);
        _p.move_spd *= boss_speed_multiplier;

        // Pequeno flash/partícula no momento do disparo também
        repeat (5) {
            var _fx = instance_create_layer(_spawn_x, _spawn_y, layer, oHitParticle);
            var _ang = random(360);
            _fx.dir_x = lengthdir_x(1, _ang);
            _fx.dir_y = lengthdir_y(1, _ang);
            _fx.color = c_aqua;
        }

        state = "idle";
        attack_cooldown = attack_cooldown_max;
        image_blend = c_white; // reseta o piscar
    }
	break;

    case "transforming":
    if (sprite_index != boss1_fase2_transformation_spr) {
        sprite_index = boss1_fase2_transformation_spr;
        image_index = 0;
        image_speed = 1;
		hittable = false;

        // Explosão de partículas no momento que entra na transformação
        repeat (20) {
			var _tp = instance_create_depth(x, y - 60, depth, oHitParticle);
			var _ang = random(360);
			var _spd_mult = random_range(1, 2);
			_tp.dir_x = lengthdir_x(1, _ang) * _spd_mult;
			_tp.dir_y = lengthdir_y(1, _ang) * _spd_mult;
			_tp.color = c_purple;
			_tp.radius = random_range(10, 10); // <<< bem maiores, é o momento mais dramático
			_tp.fade_speed = 0.03; // <<< fade mais lento também, fica mais tempo visível
		}
    }

    transform_timer -= 1;

    // Pulsa a cor durante a transformação (efeito "carregando poder")
    image_blend = merge_color(c_white, c_purple, abs(sin(current_time / 100)));

    if (image_index >= image_number -1 && transform_timer <= 0) {
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
        image_speed = boss_speed_multiplier;
        water_spawned = false; // reseta a trava toda vez que entra no ataque
    }

    // Dispara quase no fim da animação (1 frame antes do último, ajusta o "- 2" se quiser mais cedo/tarde)
    if (!water_spawned && image_index >= image_number - 2) {
        water_spawned = true;

        var _water_sfx = audio_play_sound(snd_harpoon_heavy, 2, false);
        audio_sound_pitch(_water_sfx, 0.68);
        audio_sound_gain(_water_sfx, 0.58, 0);

        var _dir = point_direction(x, y, oPlayer.x, oPlayer.y);

        var _spawn_x = x + water_spawn_offset_x;
        var _spawn_y = y + water_spawn_offset_y;

        water_projectile = instance_create_depth(_spawn_x, _spawn_y, depth, oBossWaterProjectile);
        water_projectile.dir = _dir + 180; // ou o offset que você calibrou
        water_projectile.image_xscale = 0.1;
        water_projectile.grow_speed *= boss_speed_multiplier;
        water_projectile.active_time = ceil(water_projectile.active_time / boss_speed_multiplier);
    }

    // Espera a animação terminar de verdade antes de trocar de estado
    if (image_index >= image_number - 1) {
        image_index = image_number - 1;
        image_speed = 0;
        state = "attack_water_active";
    }
	break;
	
	case "attack_water_active":

    // Mantém o boss no último frame
    image_index = image_number - 1;
    image_speed = 0;

    // Enquanto o jato existir, mantém o ataque
    if (!instance_exists(water_projectile)) {
        state = "idle2";
        phase2_attack_cooldown = phase2_attack_cooldown_max;
    }
	break;
	
	case "attack_eyedrop_windup":
    if (sprite_index != boss1fase2_attack2_spr) {
        sprite_index = boss1fase2_attack2_spr;
        image_index = 0;
        image_speed = boss_speed_multiplier;
    }

    if (image_index >= image_number - 1) {
        state = "attack_eyedrop_warning";
        warning_started = false; // garante que a zona vermelha começa do zero
    }
	break;
	
	case "attack_eyedrop_warning":
    sprite_index = boss1_fase2_idle2_spr; // fica parado olhando enquanto isso acontece

    if (!warning_started) {
        warning_started = true;
        eyedrop_warning_timer = eyedrop_warning_time;

        // Junta todas as plataformas da room (trocar oGround pelo objeto real das suas plataformas dps)
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
            _w.target_plat = _plat;
        }

        ds_list_destroy(_platforms);
    }

    eyedrop_warning_timer -= 1;
    if (eyedrop_warning_timer <= 0) {
        state = "idle2";
        phase2_attack_cooldown = phase2_attack_cooldown_max;
        warning_started = false;
    }
	break;

    case "idle2":
    sprite_index = boss1_fase2_idle_spr;

    phase2_attack_cooldown -= boss_speed_multiplier;
    if (phase2_attack_cooldown <= 0) {
        // Alterna os golpes para a luta variar sem repetir ataques injustos.
        last_phase2_attack = 1 - last_phase2_attack;
        state = (last_phase2_attack == 0) ? "attack_water_windup" : "attack_eyedrop_windup";
    }
	break;
	
	case "dying":
    image_speed = 0; // congela a animação no frame atual

    if (!final_explosion_started) {
        death_timer -= 1;

        // Aceleracao visual: quanto mais perto de zero, mais rapido pisca.
        var _blink_rate = max(2, ceil(death_timer / 18));
        image_blend = (death_timer mod (_blink_rate * 2) < _blink_rate) ? c_white : c_red;

        if (death_timer mod 6 == 0) {
            repeat (15) {
                var _ex = random_range(-sprite_width / 2, sprite_width / 2);
                var _ey = random_range(-sprite_height / 2, sprite_height / 2);
                var _p = instance_create_depth(x + _ex, y + _ey, depth - 10, oHitParticle);
                var _ang = random(360);
                var _spd = random_range(2, 6);
                _p.dir_x = lengthdir_x(1, _ang) * _spd;
                _p.dir_y = lengthdir_y(1, _ang) * _spd;
                _p.color = choose(c_aqua, c_white, c_yellow, c_orange, c_red);
                _p.radius = random_range(7, 18);
                _p.fade_speed = 0.035;
            }
            if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 7;
        }

        if (death_timer <= 0) {
            final_explosion_started = true;
            final_explosion_timer = 80;
            image_alpha = 0;

            var _boom_sfx = audio_play_sound(snd_boss_explosion, 10, false);
            audio_sound_gain(_boom_sfx, 0.78, 0);

            // Nucleo da explosao: fragmentos quentes, agua e energia.
            repeat (120) {
                var _fx = random_range(-sprite_width, sprite_width);
                var _fy = random_range(-sprite_height, sprite_height);
                var _p2 = instance_create_depth(x + _fx, y + _fy, depth - 10, oHitParticle);
                var _ang2 = random(360);
                var _spd2 = random_range(5, 13);
                _p2.dir_x = lengthdir_x(1, _ang2) * _spd2;
                _p2.dir_y = lengthdir_y(1, _ang2) * _spd2;
                _p2.color = choose(c_aqua, c_blue, c_yellow, c_orange, c_white, c_red, c_purple);
                _p2.radius = random_range(12, 32);
                _p2.fade_speed = random_range(0.014, 0.030);
            }
            if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 24;
        }
    } else {
        final_explosion_timer--;

        // Duas ondas secundarias, visiveis antes da troca de room.
        if (final_explosion_timer == 58 || final_explosion_timer == 34) {
            repeat (54) {
                var _ring_ang = irandom(359);
                var _ring = instance_create_depth(x, y, depth - 12, oHitParticle);
                var _ring_spd = (final_explosion_timer == 58) ? 8 : 5;
                _ring.dir_x = lengthdir_x(1, _ring_ang) * _ring_spd;
                _ring.dir_y = lengthdir_y(1, _ring_ang) * _ring_spd;
                _ring.color = choose(c_white, c_aqua, c_yellow);
                _ring.radius = random_range(8, 20);
                _ring.fade_speed = 0.022;
            }
            if (instance_exists(oCameraController_boss)) {
                oCameraController_boss.shake_amount = max(oCameraController_boss.shake_amount, 12);
            }
        }

        if (final_explosion_timer <= 0) room_goto(PhaseTransition);
    }
	break;
}


// --- INVENCIBILIDADE E FLASH DE DANO ---
if (invuln_timer > 0) {
    invuln_timer -= 1;
}
if (hit_flash_timer > 0) {
    hit_flash_timer -= 1;
}

if (state != "dying") {
    image_blend = (hit_flash_timer > 0) ? c_white : c_red;
    if (invuln_timer <= 0) {
        image_blend = c_white; // volta ao normal fora da invencibilidade
    }
}
