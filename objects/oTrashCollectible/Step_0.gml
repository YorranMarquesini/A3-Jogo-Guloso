if (place_meeting(x, y, oPlayer)) {
    if (oPlayer.hp < oPlayer.max_hp) {
        oPlayer.hp += 1;
    }

    // --- REDUZ A POLUIÇÃO (dinâmico conforme o total da fase) ---
    if (variable_global_exists("pollution_pct")) {
        global.pollution_pct = max(0, global.pollution_pct - global.pollution_reduction_per_item);
    }

    // Feedback visual de coleta
    repeat (6) {
        var _p = instance_create_depth(x, y, depth, oHitParticle);
        var _ang = random(360);
        _p.dir_x = lengthdir_x(1, _ang);
        _p.dir_y = lengthdir_y(1, _ang);
        _p.color = c_lime;
        _p.radius = random_range(4, 8);
    }

    instance_destroy();

    // Se esse era o último da fase, ganha coração permanente
    if (instance_number(oTrashCollectible) == 0) {
        scr_grant_permanent_heart();

        // Efeito mais chamativo pra reforçar a conquista
        repeat (20) {
            var _p2 = instance_create_depth(oPlayer.x, oPlayer.y - 20, oPlayer.depth, oHitParticle);
            var _ang2 = random(360);
            _p2.dir_x = lengthdir_x(1, _ang2) * random_range(1, 2.5);
            _p2.dir_x = lengthdir_x(1, _ang2) * random_range(1, 2.5);
            _p2.dir_y = lengthdir_y(1, _ang2) * random_range(1, 2.5);
            _p2.color = c_yellow;
            _p2.radius = random_range(8, 16);
            _p2.fade_speed = 0.03;
        }

        if (instance_exists(oCameraController_boss)) {
            oCameraController_boss.shake_amount = 3;
        }
    }
}