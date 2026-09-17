function scr_damage_player(_amount, _source_x) {
    if (!instance_exists(oPlayer)) return;

    with (oPlayer) {
        if (hp_invuln_timer > 0 || is_invincible) {
            exit; // já invencível (dash ou i-frames), ignora o dano
        }

        hp -= _amount;
        hp_invuln_timer = hp_invuln_time;

        // Knockback: empurra pro lado oposto da fonte de dano
        var _dir = (x < _source_x) ? -1 : 1;
        hsp = _dir * knockback_force;
        vsp = -4; // um pouquinho pra cima, dá aquele "impacto"

        // Feedback visual rápido (reaproveita o mesmo esquema de partículas)
        repeat (8) {
            var _p = instance_create_depth(x, y - 20, depth, oHitParticle);
            var _ang = random(360);
            _p.dir_x = lengthdir_x(1, random_range(1, 2.5)) * cos(degtorad(_ang));
            _p.dir_y = lengthdir_y(1, random_range(1, 2.5)) * sin(degtorad(_ang));
            _p.color = c_red;
            _p.radius = random_range(6, 10);
        }

        if (instance_exists(oCameraController_boss)) {
            oCameraController_boss.shake_amount = 5;
        }

        if (hp <= 0) {
            hp = 0;
            // TODO: game over / respawn — por enquanto só zera
            show_debug_message("PLAYER MORREU");
        }
    }
}