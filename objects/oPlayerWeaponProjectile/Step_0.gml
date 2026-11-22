x += dir_x * move_spd;
image_angle += spin_speed * dir_x;

lifetime -= 1;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// --- EFEITO DE RASTRO ---
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

// =========================================================
// BÔNUS DOS COLETÁVEIS CONTRA O BOSS DA FASE 2
// Usa uma linha entre a posição anterior e a atual para o projétil rápido
// não atravessar a fumaça ou o chapéu entre dois frames.
// =========================================================
if (instance_exists(oCagliostro)) {
    var _cagliostro = instance_find(oCagliostro, 0);

    var _can_break_smoke = variable_global_exists("fase1_collectibles_complete")
        && global.fase1_collectibles_complete
        && thrown_weapon_type == "arpao"
        && _cagliostro.smoke_break_cooldown <= 0;

    if (_can_break_smoke) {
        var _smoke_hit = collision_line(xprevious, yprevious, x, y, oCagliostroSmoke, false, true);
        if (_smoke_hit != noone) {
            var _effect_x = _smoke_hit.x;
            var _effect_y = _smoke_hit.y;
            with (_smoke_hit) instance_destroy();

            _cagliostro.smoke_break_cooldown = _cagliostro.smoke_break_cooldown_max;

            repeat (14) {
                var _smoke_particle = instance_create_depth(_effect_x, _effect_y, depth, oHitParticle);
                var _smoke_angle = random(360);
                _smoke_particle.dir_x = lengthdir_x(random_range(1.5, 3.5), _smoke_angle);
                _smoke_particle.dir_y = lengthdir_y(random_range(1.5, 3.5), _smoke_angle);
                _smoke_particle.color = choose(c_white, c_gray, c_silver);
                _smoke_particle.radius = random_range(5, 11);
            }

            if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 5;
            instance_destroy();
            exit;
        }
    }

    var _can_break_hat = variable_global_exists("fase2_collectibles_complete")
        && global.fase2_collectibles_complete
        && thrown_weapon_type == "tesoura"
        && _cagliostro.hat_break_cooldown <= 0;

    if (_can_break_hat) {
        var _hat_hit = collision_line(xprevious, yprevious, x, y, oCagliostroHat, false, true);
        if (_hat_hit != noone) {
            var _hat_effect_x = _hat_hit.x;
            var _hat_effect_y = _hat_hit.y;
            with (_hat_hit) instance_destroy();

            _cagliostro.hat_break_cooldown = _cagliostro.hat_break_cooldown_max;
            _cagliostro.hat_disabled_timer = _cagliostro.hat_disabled_duration;
            _cagliostro.state = "combat";
            _cagliostro.attack_fired = false;
            _cagliostro.attack_timer = max(_cagliostro.attack_timer, 45);

            repeat (18) {
                var _hat_particle = instance_create_depth(_hat_effect_x, _hat_effect_y, depth, oHitParticle);
                var _hat_angle = random(360);
                _hat_particle.dir_x = lengthdir_x(random_range(2, 4.5), _hat_angle);
                _hat_particle.dir_y = lengthdir_y(random_range(2, 4.5), _hat_angle);
                _hat_particle.color = choose(c_black, c_dkgray, c_red);
                _hat_particle.radius = random_range(5, 12);
                _hat_particle.fade_speed = 0.035;
            }

            if (instance_exists(oCameraController_boss)) oCameraController_boss.shake_amount = 8;
            instance_destroy();
            exit;
        }
    }
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
if (scr_try_hit_enemy(x, y, thrown_weapon_type, false)) {
    instance_destroy();
}
