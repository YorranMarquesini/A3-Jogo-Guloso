x += dir_x * move_spd;
image_angle += spin_speed * dir_x;

lifetime -= 1;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// --- EFEITO DE RASTRO (reaproveita o oAfterimage que já existe) ---
trail_timer -= 1;
if (trail_timer <= 0) {
    trail_timer = trail_interval;
    var _t = instance_create_depth(x, y, depth, oAfterimage);
    _t.sprite_index = sprite_index;
    _t.image_index = 0;
    _t.image_xscale = image_xscale;
    _t.image_yscale = image_yscale;
    _t.image_angle = image_angle;
}

// --- DESTRÓI AO SAIR DA VIEW ---
var _margin = 32;
var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

if (x < _view_x - _margin || x > _view_x + _view_w + _margin ||
    y < _view_y - _margin || y > _view_y + _view_h + _margin) {
    instance_destroy();
    exit;
}

// --- DANO NO BOSS ---
if (asset_get_index("oEnemy") != -1) {
    var _hit = instance_place(x, y, oEnemy);
    if (_hit != noone) {
        with (_hit) {
            if (invuln_timer <= 0 && hittable) {
                hp -= 1;
                invuln_timer = invuln_time;
                hit_flash_timer = 8;

                repeat (14) {
                    var _p = instance_create_layer(x, y - 20, layer, oHitParticle);
                    var _ang = random(360);
                    var _spd_mult = random_range(1.5, 3);
                    _p.dir_x = lengthdir_x(1, _ang) * _spd_mult;
                    _p.dir_y = lengthdir_y(1, _ang) * _spd_mult;
                    _p.radius = random_range(8, 14);
                }

                if (instance_exists(oCameraController_boss)) {
                    oCameraController_boss.shake_amount = 4;
                }

                if (hp <= 0 && phase == 1 && state != "transforming") {
                    state = "transforming";
                    transform_timer = transform_duration;
                    if (instance_exists(oCameraController_boss)) {
                        oCameraController_boss.shake_amount = 10;
                    }
                }
            }
        }
		if (_hit.hittable) {
        instance_destroy(); // só destrói o próprio projétil se realmente acertou algo vulnerável
		}
    }
}