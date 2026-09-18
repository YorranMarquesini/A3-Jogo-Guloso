// ============================
// STEP EVENT - oPlayer
// ============================

// --- INPUT ---
var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _up = keyboard_check(vk_up) || keyboard_check(ord("W"));
var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));
var _jump_pressed = keyboard_check_pressed(vk_space);
var _jump_released = keyboard_check_released(vk_space);
var _dash_pressed = keyboard_check_pressed(vk_shift);
var _attack_pressed = mouse_check_button_pressed(mb_left);
var _heavy_pressed = keyboard_check_pressed(ord("R"));
var _throw_pressed = mouse_check_button_pressed(mb_right);
var _move = _right - _left;

if (keyboard_check_pressed(ord("Q"))) {
    scr_switch_weapon(1);
}

// =========================================================
// --- TRAVA DE MOVIMENTO DURANTE O DIÁLOGO ---
// =========================================================
if (instance_exists(obj_dialogo)) {
    hsp = 0;

    var _on_ground_dialog = place_meeting(x, y + 1, oGround) || place_meeting(x, y + 1, oWall);
    if (!_on_ground_dialog) {
        vsp = min(vsp + grav, max_fall);
    } else {
        vsp = 0;
    }

    if (place_meeting(x, y + vsp, oGround) || place_meeting(x, y + vsp, oWall)) {
        while (!(place_meeting(x, y + sign(vsp), oGround) || place_meeting(x, y + sign(vsp), oWall))) {
            y += sign(vsp);
        }
        vsp = 0;
    }
    y += vsp;

    state = "idle";
    sprite_index = (facing == "right") ? player_right_idle : player_left_idle;

    exit;
}
// =========================================================

// --- DIRECTION BUFFER ---
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
    dir_buffer_dir = 1;
    dir_buffer_counter = dir_buffer_time;
} else if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
    dir_buffer_dir = -1;
    dir_buffer_counter = dir_buffer_time;
} else {
    dir_buffer_counter = max(dir_buffer_counter - 1, 0);
}
var _effective_move = (dir_buffer_counter > 0) ? dir_buffer_dir : _move;

// --- GROUND CHECK ---
var _on_ground = place_meeting(x, y + 1, oGround) || place_meeting(x, y + 1, oWall);

if (_on_ground) {
    coyote_counter = coyote_time;
    jump_count = 0;
    can_dash = true;
    wall_jump_used_dir = 0;
    wall_jump_stage = 0;
} else {
    coyote_counter = max(coyote_counter - 1, 0);
}

// --- WALL CHECK ---
var _wall_y = y - wall_check_yoffset;
var _wall_right = place_meeting(x + wall_check_dist, _wall_y, oWall);
var _wall_left  = place_meeting(x - wall_check_dist, _wall_y, oWall);

if (_wall_right) {
    wall_dir = 1;
} else if (_wall_left) {
    wall_dir = -1;
} else {
    wall_dir = 0;
}

var _touching_wall = (wall_dir != 0 && !_on_ground);
var _new_wall_contact = (_touching_wall && !wall_touch_prev);

// --- WALL RELEASE BUFFER ---
if (_touching_wall && wall_dir != 0 && _move == -wall_dir) {
    wall_release_counter += 1;
} else {
    wall_release_counter = 0;
}
var _wall_release = (wall_release_counter >= wall_release_time);

is_wall_sliding = (_touching_wall && vsp > 0 && !is_dashing && !_wall_release);

if (_touching_wall) {
    wall_coyote_counter = wall_coyote_time;
} else {
    wall_coyote_counter = max(wall_coyote_counter - 1, 0);
}

if (_new_wall_contact && wall_dir != wall_jump_used_dir) {
    can_dash = true;
    jump_count = 0;
    wall_jump_stage = 0;
}

wall_touch_prev = _touching_wall;

// --- JUMP BUFFER ---
jump_buffer_counter = _jump_pressed ? jump_buffer : max(jump_buffer_counter - 1, 0);

// --- COOLDOWNS ---
if (dash_cooldown > 0)   dash_cooldown -= 1;
if (attack_cooldown > 0) attack_cooldown -= 1;
if (heavy_cooldown > 0)  heavy_cooldown -= 1;
if (throw_cooldown > 0)  throw_cooldown -= 1;

// --- INVENCIBILIDADE POR DANO ---
if (hp_invuln_timer > 0) {
    hp_invuln_timer -= 1;
}

// --- INVENCIBILIDADE (DASH, dura mais que o dash em si) ---
if (invuln_timer > 0) {
    invuln_timer -= 1;
}
is_invincible = (invuln_timer > 0);

// ============================
// ARREMESSO DE ARMA (SÓ NA SALA DO BOSS)
// ============================
if (_throw_pressed && has_weapon && throw_cooldown <= 0 && !is_attacking && !is_heavy_attacking && !is_dashing && instance_exists(oCameraController_boss)) {

    throw_cooldown = throw_cooldown_max;
    is_throwing = true;
    throw_anim_timer = throw_anim_duration;

    var _throw_dir = (facing == "right") ? 1 : -1;
    var _spawn_x = x + (weapon_offset_x * _throw_dir);
    var _spawn_y = y + weapon_offset_y;

    if (weapon_type == "arpao") {
        // Lança só a PONTA — a arma na mão vira arpaoShot_spr (sem ponta)
        var _tip = instance_create_depth(_spawn_x, _spawn_y, depth, oPlayerWeaponProjectile);
        _tip.sprite_index = arpaoPonta_spr;
        _tip.dir_x = _throw_dir;
        _tip.thrown_weapon_type = weapon_type;
		weapon_angle = stab_angle_offset;
        _tip.spin_speed = 0;           // a ponta não gira, já nasce alinhada (origem esquerda-centro)
        _tip.image_angle = 0;
        _tip.image_xscale = 2 * _throw_dir; // espelha pro lado certo

    } else {
        // Tesoura: comportamento de sempre (arma inteira gira e voa)
        var _proj = instance_create_depth(_spawn_x, _spawn_y, depth, oPlayerWeaponProjectile);
        _proj.sprite_index = weapon_sprite;
        _proj.dir_x = _throw_dir;
        _proj.thrown_weapon_type = weapon_type;
    }
}

if (is_throwing) {
    throw_anim_timer -= 1;
    if (throw_anim_timer <= 0) {
        is_throwing = false;
    }
}

// ============================
// ATAQUE FORTE (R)
// ============================
if (_heavy_pressed && has_weapon && heavy_cooldown <= 0 && !is_attacking && !is_heavy_attacking && !is_dashing && !instance_exists(oCameraController_boss)) {
    is_heavy_attacking = true;
    heavy_cooldown = heavy_cooldown_max;
    heavy_attack_timer = (weapon_type == "tesoura") ? sweep_duration : stab_duration;
}

if (is_heavy_attacking) {
    heavy_attack_timer -= 1;
    var _hdir = (facing == "right") ? 1 : -1;

    if (weapon_type == "tesoura") {
		var _sweep_progress = 1 - (heavy_attack_timer / sweep_duration);

		// Curva "ease out" — rápido no início, desacelera no fim (mais "cortante")
		var _eased = 1 - power(1 - _sweep_progress, 3);

		weapon_angle = lerp(sweep_angle_start, sweep_angle_end, _eased) * _hdir;

		// Afasta a arma do corpo durante o meio do swing (arco maior, não só girando no lugar)
		var _swing_reach = sin(_sweep_progress * pi) * sweep_extra_reach;

		var _sweep_hb_x = x + ((weapon_offset_x + telekinesis_push_x) * _hdir);
		var _sweep_hb_y = y + weapon_offset_y + 10;
	
		scr_try_hit_enemy(_sweep_hb_x, _sweep_hb_y, weapon_type, true);
	
	} else if (weapon_type == "arpao") {
		var _stab_progress = 1 - (heavy_attack_timer / stab_duration);

		if (_stab_progress < 0.5) {
			hsp = _hdir * stab_lunge_speed;
		} else {
			hsp = approach(hsp, 0, 1);
		}

		weapon_angle = stab_angle_offset // <<< ângulo fixo pra deixar reto, espelha conforme o lado

		var _stab_hb_x = x + ((weapon_offset_x + telekinesis_push_x + stab_reach) * _hdir);
		var _stab_hb_y = y + weapon_offset_y;

		scr_try_hit_enemy(_stab_hb_x, _stab_hb_y, weapon_type, true);
	}

    if (heavy_attack_timer <= 0) {
        is_heavy_attacking = false;
        weapon_angle = 0;
    }
}

// ============================
// ATAQUE NORMAL (bonk de cima pra baixo)
// ============================
if (_attack_pressed && has_weapon && attack_cooldown <= 0 && !is_attacking && !is_heavy_attacking && !is_dashing && !instance_exists(oCameraController_boss)) {
    is_attacking = true;
    attack_timer = attack_duration;
    attack_cooldown = attack_cooldown_max;
}

if (is_attacking) {
    attack_timer -= 1;

    var _progress = 1 - (attack_timer / attack_duration);
    weapon_angle = lerp(70, -50, _progress);

    if (_progress > 0.35 && _progress < 0.7) {
        var _hb_x = x + ((weapon_offset_x + telekinesis_push_x) * (facing == "right" ? 1 : -1));
        var _hb_y = y + weapon_offset_y + 10;

        scr_try_hit_enemy(_hb_x, _hb_y, weapon_type, false);
    }

    if (attack_timer <= 0) {
        is_attacking = false;
        weapon_angle = 0;
    }
} else if (!is_heavy_attacking) {
    weapon_angle = 0;
}

// ============================
// DASH
// ============================
if (_dash_pressed && can_dash && dash_cooldown <= 0 && !is_dashing) {
    is_dashing = true;
    can_dash = false;
    dash_timer = dash_time;
    dash_cooldown = dash_cooldown_max;
    invuln_timer = dash_invuln_time;

    var _dx = _right - _left;
    var _dy = _down - _up;

    if (_dx == 0 && _dy == 0) {
        dash_dir_x = (facing == "right") ? 1 : -1;
        dash_dir_y = 0;
    } else {
        var _len = point_distance(0, 0, _dx, _dy);
        dash_dir_x = _dx / _len;
        dash_dir_y = _dy / _len;
    }

    // --- PARTÍCULA NA SAÍDA DO DASH ---
    repeat (14) {
        var _p = instance_create_depth(x, y - 20, depth, oHitParticle);
        var _ang = random(360);
        var _spd_mult = random_range(1.5, 3);
        _p.dir_x = lengthdir_x(1, _ang) * _spd_mult;
        _p.dir_y = lengthdir_y(1, _ang) * _spd_mult;
        _p.radius = random_range(4, 6);
    }
}

// ============================
// LÓGICA PRINCIPAL (movimento / pulo / dash em andamento)
// ============================
if (is_dashing) {
    dash_timer -= 1;
    hsp = dash_dir_x * dash_speed;
    vsp = dash_dir_y * dash_speed;

    // --- AFTERIMAGE ---
    afterimage_timer -= 1;
    if (afterimage_timer <= 0) {
        afterimage_timer = afterimage_interval;
        var _ghost = instance_create_depth(x, y, depth, oAfterimage);
        _ghost.sprite_index = sprite_index;
        _ghost.image_index = image_index;
        _ghost.image_xscale = image_xscale;
        _ghost.image_yscale = image_yscale;
    }

    if (place_meeting(x + hsp, y, oGround) || place_meeting(x + hsp, y, oWall)) {
        is_dashing = false;
        dash_timer = 0;
        hsp = 0;
    }

    if (dash_timer <= 0) {
        is_dashing = false;
        hsp *= 0.5;
        vsp *= 0.5;
    }

} else {
    // --- MOVIMENTO HORIZONTAL ---
    var _current_acc = _on_ground ? acc : air_acc;

    if (wall_jump_lock > 0) {
        wall_jump_lock -= 1;

    } else if (_touching_wall && !_wall_release) {
        hsp = 0;

    } else if (_move != 0 && !is_heavy_attacking) {
        hsp = approach(hsp, _move * move_speed, _current_acc);
    } else if (!is_heavy_attacking) {
        hsp = approach(hsp, 0, _on_ground ? dec : air_acc);
    }

    // --- PULO ---
    if (jump_buffer_counter > 0 && !is_attacking && !is_heavy_attacking) {
        if (coyote_counter > 0) {
            vsp = jump_force;
            jump_count = 1;
            jump_buffer_counter = 0;
            coyote_counter = 0;

        } else if (wall_coyote_counter > 0 && wall_dir != 0 && wall_dir != wall_jump_used_dir) {
            vsp = wall_jump_force_y;
            hsp = (_effective_move == -wall_dir) ? (-wall_dir * wall_jump_force_x) : 0;

            jump_count = max_jumps;
            jump_buffer_counter = 0;
            wall_coyote_counter = 0;
            wall_jump_lock = wall_jump_lock_time;
            wall_jump_used_dir = wall_dir;
            wall_jump_stage = (hsp == 0) ? 1 : 2;
            dir_buffer_counter = 0;

        } else if (wall_jump_stage == 1 && _effective_move == -wall_jump_used_dir) {
            vsp = wall_jump_force_y;
            hsp = -wall_jump_used_dir * wall_jump_force_x;

            jump_buffer_counter = 0;
            wall_jump_lock = wall_jump_lock_time;
            wall_jump_stage = 2;
            dir_buffer_counter = 0;

        } else if (jump_count < max_jumps) {
            vsp = jump_force * 0.9;
            jump_count += 1;
            jump_buffer_counter = 0;
        }
    }

    // --- PULO VARIÁVEL ---
    if (_jump_released && vsp < 0) {
        vsp *= jump_cut_multiplier;
    }

    // --- GRAVIDADE ---
    vsp = is_wall_sliding ? min(vsp + grav, wall_slide_speed) : min(vsp + grav, max_fall);
}

// ============================
// COLISÃO
// ============================
if (place_meeting(x + hsp, y - 4, oGround) || place_meeting(x + hsp, y - 4, oWall)) {
    while (!(place_meeting(x + sign(hsp), y - 4, oGround) || place_meeting(x + sign(hsp), y - 4, oWall))) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, oGround) || place_meeting(x, y + vsp, oWall)) {
    while (!(place_meeting(x, y + sign(vsp), oGround) || place_meeting(x, y + sign(vsp), oWall))) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;

x = round(x);
y = round(y);

// ============================
// FACING E ANIMAÇÃO
// ============================
if (hsp != 0 && !is_heavy_attacking) {
    facing = (hsp > 0) ? "right" : "left";
}

state = (hsp != 0 || is_dashing || !_on_ground) ? "walk" : "idle";

if (state == "idle") {
    sprite_index = (facing == "right") ? player_right_idle : player_left_idle;
} else {
    sprite_index = (facing == "right") ? player_right_walk : player_left_walk;
}

spirit_bob_timer += spirit_bob_speed;
telekinesis_angle += telekinesis_orbit_speed;