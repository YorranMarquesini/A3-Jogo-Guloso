if (!landed) {
    fall_speed = min(fall_speed + fall_gravity, fall_max_speed);
    y += fall_speed;

    if (place_meeting(x, y, oPlayer)) {
        scr_damage_player(1, x + 500);
    }

    if (y >= drop_target_y) {
        y = drop_target_y;
        landed = true;

        repeat (12) {
            var _p = instance_create_depth(x, y, depth, oHitParticle);
            var _ang = random(360);
            _p.dir_x = lengthdir_x(1, _ang);
            _p.dir_y = lengthdir_y(1, _ang);
            _p.color = c_purple;
            _p.radius = random_range(6, 12);
        }

        if (instance_exists(oCameraController_boss)) {
            oCameraController_boss.shake_amount = 6;
        }

        alarm[0] = 20; // some pouco depois do impacto
    }
} else if (place_meeting(x, y, oPlayer)) {
    scr_damage_player(1, x);
}