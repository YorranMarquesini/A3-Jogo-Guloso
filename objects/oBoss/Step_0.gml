switch (state) {

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
        image_speed = 1;
    }

    // Pisca em amarelo/vermelho durante o windup como aviso
    image_blend = (hit_flash_timer > 0) ? c_white :
                  (sin(current_time / 60) > 0 ? c_yellow : c_white);

    if (image_index >= image_number) {
        var _spawn_x = x;
        var _spawn_y = y - 20;

        var _p = instance_create_layer(_spawn_x, _spawn_y, layer, oBossProjectile);

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

        // Explosão de partículas no momento que entra na transformação
        repeat (20) {
			var _tp = instance_create_layer(x, y - 60, layer, oHitParticle);
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
        state = "idle2";
        image_blend = c_white;
    }
	break;

    case "idle2":
        sprite_index = boss1_fase2_idle_spr;
        // TODO: ataques da fase 2 entram aqui depois
		hp = 60;
    break;
}

// --- INVENCIBILIDADE E FLASH DE DANO ---
if (invuln_timer > 0) {
    invuln_timer -= 1;
}
if (hit_flash_timer > 0) {
    hit_flash_timer -= 1;
}

image_blend = (hit_flash_timer > 0) ? c_white : c_red;
if (invuln_timer <= 0) {
    image_blend = c_white; // volta ao normal fora da invencibilidade
}