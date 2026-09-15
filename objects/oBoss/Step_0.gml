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
        image_index = 0;       // garante que a animação começa do frame 0
        image_speed = 1;
    }

    // Espera a animação percorrer TODOS os frames antes de disparar
    if (image_index >= image_number) {
		var _spawn_x = x;
		var _spawn_y = y -140;  // ajusta esse valor até bater com a altura da cabeça dele
        var _p = instance_create_layer(x, y, layer, oBossProjectile);
        _p.target = oPlayer;

        state = "idle";
        attack_cooldown = attack_cooldown_max;
    }
	break;

    case "transforming":
        sprite_index = boss1_fase2_transformation_spr;
        transform_timer -= 1;

        if (image_index >= image_number -1 && transform_timer <= 0) {
            phase = 2;
            state = "idle2";
        }
    break;

    case "idle2":
        sprite_index = boss1_fase2_idle_spr;
        // TODO: ataques da fase 2 entram aqui depois
    break;
}

// --- INVENCIBILIDADE E FLASH DE DANO ---
if (invuln_timer > 0) {
    invuln_timer -= 1;
}
image_blend = (invuln_timer > 0) ? c_red : c_white;