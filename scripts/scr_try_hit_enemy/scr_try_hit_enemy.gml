function scr_try_hit_enemy(_x, _y, _weapon_type, _is_heavy) {
    if (asset_get_index("oEnemy") == -1) return false;

    var _hit = instance_place(_x, _y, oEnemy);
    if (_hit == noone) return false;

    var _did_damage = false;

    with (_hit) {
        if (invuln_timer <= 0 && hittable) {
            _did_damage = true;

            var _dmg = scr_get_weapon_damage(_weapon_type, material);
            if (_is_heavy) _dmg *= 2;

            hp -= _dmg;
            invuln_timer = invuln_time;
            hit_flash_timer = 8;

            repeat (_is_heavy ? 20 : 14) {
                var _p = instance_create_depth(x, y - 20, depth, oHitParticle);
                var _ang = random(360);
                var _spd_mult = random_range(1.5, 3);
                _p.dir_x = lengthdir_x(1, _ang) * _spd_mult;
                _p.dir_y = lengthdir_y(1, _ang) * _spd_mult;
                _p.radius = _is_heavy ? random_range(10, 18) : random_range(8, 14);
            }

            if (instance_exists(oCameraController_boss)) {
                oCameraController_boss.shake_amount = _is_heavy ? 7 : 4;
            }

            if (hp <= 0) {
                if (phase == 1 && state != "transforming") {
                    state = "transforming";
                    transform_timer = transform_duration;
                    if (instance_exists(oCameraController_boss)) {
                        oCameraController_boss.shake_amount = 10;
                    }
                } else if (phase == 2 && state != "dying") {
                    state = "dying";
                    hittable = false;
                    death_timer = death_duration;
                }
            }
        }
    }

    return _did_damage;
}