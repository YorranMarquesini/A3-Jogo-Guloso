var _pad = scr_gamepad_slot();
var _pad_dir = pad_directions(_pad);

// ============================
// STEP EVENT - oPlayer
// ============================

// Durante o pouso, a cutscene controla a posicao e o input fica travado.
if ((variable_global_exists("player_cutscene_locked") && global.player_cutscene_locked)
|| (instance_exists(oCagliostro) && oCagliostro.state == "dying")) {
    hsp = 0;
    vsp = 0;
    wall_hold_frames = 0;
    state = "idle";
    sprite_index = (facing == "right") ? player_right_idle : player_left_idle;
    exit;
}

// --- INPUT ---
var _left = (_pad_dir.dx < 0);
var _right = (_pad_dir.dx > 0);
var _up = (_pad_dir.dy < 0);
var _down = (_pad_dir.dy > 0);
var _jump_pressed = controls_read(Bind.jump, _pad);
var _jump_released = controls_read(Bind.jump, _pad, BindState.released);
var _dash_pressed = controls_read(Bind.dash, _pad);
var _attack_pressed = controls_read(Bind.attack, _pad);
var _heavy_pressed = controls_read(Bind.heavy, _pad);
var _throw_pressed = controls_read(Bind.toss, _pad);
var _move = _right - _left;

// FISICA SUBAQUATICA DA FASE 1
// O lago nao usa colisao: a area visual do efeito define quando o player esta submerso.
is_underwater = false;
var _lake = instance_find(oLakeEffect, 0);
if (instance_exists(_lake)) {
    is_underwater = x >= _lake.x
                 && x <= _lake.x + _lake.lake_width
                 && y >= _lake.y + 12
                 && y <= _lake.y + _lake.lake_height;
}

var _active_grav = is_underwater ? grav * 0.34 : grav;
var _active_max_fall = is_underwater ? 3.2 : max_fall;
var _active_jump_force = is_underwater ? -5.6 : jump_force;
var _active_wall_jump_force_y = is_underwater ? -5.2 : wall_jump_force_y;
var _active_jump_cut = is_underwater ? 0.82 : jump_cut_multiplier;

if (controls_read(Bind.weapon, _pad)) {
    scr_switch_weapon(1);
}

// =========================================================
// --- TRAVA DE MOVIMENTO DURANTE O DIÁLOGO ---
// =========================================================
if (instance_exists(obj_dialogo) || instance_exists(oCagliostroCutscene)) {
    hsp = 0;

    wall_hold_frames = 0;
    var _on_ground_dialog = place_meeting(x, y + 1, oGround) || place_meeting(x, y + 1, oWall);
    if (!_on_ground_dialog) {
        vsp = min(vsp + _active_grav, _active_max_fall);
    } else {
        vsp = 0;
    }

    if (move_player_axis(vsp, false)) vsp = 0;

    state = "idle";
    sprite_index = (facing == "right") ? player_right_idle : player_left_idle;

    exit;
}
// =========================================================

// --- DIRECTION BUFFER ---
if ((_pad_dir.press_x > 0)) {
    dir_buffer_dir = 1;
    dir_buffer_counter = dir_buffer_time;
} else if ((_pad_dir.press_x < 0)) {
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
var _wall_right = place_meeting(x + wall_check_dist, y, oWall) && place_meeting(x + wall_check_dist, _wall_y, oWall);
var _wall_left  = place_meeting(x - wall_check_dist, y, oWall) && place_meeting(x - wall_check_dist, _wall_y, oWall);

if (_wall_right) {
    wall_dir = 1;
} else if (_wall_left) {
    wall_dir = -1;
} else {
    wall_dir = 0;
}

var _touching_wall = (wall_dir != 0 && !_on_ground);
var _new_wall_contact = (_touching_wall && !wall_touch_prev);

if (_touching_wall && _move == -wall_dir) {
    if (wall_hold_dir != wall_dir) wall_hold_frames = 0;
    wall_hold_frames += 1;
    wall_hold_dir = wall_dir;
} else {
    wall_hold_frames = 0;
    wall_hold_dir = 0;
}
var _wall_release = wall_hold_frames >= wall_release_frames;

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
    var _throw_sfx = audio_play_sound(snd_weapon_throw, 3, false);
    audio_sound_gain(_throw_sfx, 0.68, 0);

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
    var _heavy_sound = (weapon_type == "tesoura") ? snd_scissors_heavy : snd_harpoon_heavy;
    var _heavy_sfx = audio_play_sound(_heavy_sound, 3, false);
    audio_sound_gain(_heavy_sfx, 0.72, 0);
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
    var _attack_sound = (weapon_type == "tesoura") ? snd_scissors_slash : snd_harpoon_thrust;
    var _attack_sfx = audio_play_sound(_attack_sound, 3, false);
    audio_sound_gain(_attack_sfx, 0.64, 0);
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
    var _dash_sfx = audio_play_sound(snd_dash, 3, false);
    audio_sound_gain(_dash_sfx, 0.62, 0);

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
        var _ghost_y = y - visual_float_height + sin(spirit_bob_timer) * spirit_bob_height;
		var _ghost = instance_create_depth(x, _ghost_y, depth, oAfterimage);
		_ghost.sprite_index = sprite_index;
		_ghost.image_index = image_index;
		_ghost.image_xscale = image_xscale;
		_ghost.image_yscale = image_yscale;
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

    // Saia do alcance da parede neste Step; o pulo abaixo ainda pode assumir o movimento.
    if (wall_hold_frames == wall_release_frames) hsp = -wall_dir * move_speed;

    // --- PULO ---
    if (jump_buffer_counter > 0 && !is_attacking && !is_heavy_attacking) {
        if (coyote_counter > 0) {
            vsp = _active_jump_force;
            jump_count = 1;
            jump_buffer_counter = 0;
            coyote_counter = 0;
			scr_spawn_jump_burst(x, y + 4, false);
			var _jump_sfx = audio_play_sound(snd_jump, 2, false);
			audio_sound_pitch(_jump_sfx, random_range(0.96, 1.04));

        } else if (wall_coyote_counter > 0 && wall_dir != 0 && wall_dir != wall_jump_used_dir) {
            vsp = _active_wall_jump_force_y;
            hsp = (_effective_move == -wall_dir) ? (-wall_dir * wall_jump_force_x) : 0;

            jump_count = max_jumps;
            jump_buffer_counter = 0;
            wall_coyote_counter = 0;
            wall_jump_lock = wall_jump_lock_time;
            wall_jump_used_dir = wall_dir;
            wall_jump_stage = (hsp == 0) ? 1 : 2;
            dir_buffer_counter = 0;
			scr_spawn_jump_burst(x, y + 4, false);
			var _wall_jump_sfx = audio_play_sound(snd_jump, 2, false);
			audio_sound_pitch(_wall_jump_sfx, 0.92);

        } else if (wall_jump_stage == 1 && _effective_move == -wall_jump_used_dir) {
            vsp = _active_wall_jump_force_y;
            hsp = -wall_jump_used_dir * wall_jump_force_x;

            jump_buffer_counter = 0;
            wall_jump_lock = wall_jump_lock_time;
            wall_jump_stage = 2;
            dir_buffer_counter = 0;
			scr_spawn_jump_burst(x, y + 4, false);
			var _wall_release_sfx = audio_play_sound(snd_jump, 2, false);
			audio_sound_pitch(_wall_release_sfx, 1.02);

        } else if (jump_count < max_jumps) {
            vsp = _active_jump_force * 0.9;
            jump_count += 1;
            jump_buffer_counter = 0;
			scr_spawn_jump_burst(x, y + 4, true);
			var _double_jump_sfx = audio_play_sound(snd_jump, 2, false);
			audio_sound_pitch(_double_jump_sfx, 1.14);
        }
    }

    // --- PULO VARIÁVEL ---
    if (_jump_released && vsp < 0) {
        vsp *= _active_jump_cut;
    }

    // --- GRAVIDADE ---
    var _active_wall_fall = is_underwater ? 1.4 : wall_slide_speed;
    vsp = is_wall_sliding
        ? min(vsp + _active_grav, _active_wall_fall)
        : min(vsp + _active_grav, _active_max_fall);
}

// ============================
// COLISÃO
// ============================
var _step_x = hsp;
var _step_y = vsp;
if (room == Fase2 && !is_dashing) {
    if (_on_ground && vsp >= 0) {
        var _floor_belt = instance_place(x, y + 1, oFactoryConveyor);
        if (_floor_belt != noone && abs(dcos(_floor_belt.image_angle)) > 0.99) {
            var _force = _floor_belt.belt_speed * sign(_floor_belt.image_xscale);
            _step_x += lengthdir_x(_force, _floor_belt.image_angle);
        }
    } else if (_touching_wall && !_wall_release) {
        var _wall_belt = instance_place(x + wall_dir * wall_check_dist, _wall_y, oFactoryConveyor);
        if (_wall_belt != noone && abs(dsin(_wall_belt.image_angle)) > 0.99) {
            var _force = _wall_belt.belt_speed * sign(_wall_belt.image_xscale);
            _step_y += lengthdir_y(_force, _wall_belt.image_angle);
        }
    }
}

var _hit_x = move_player_axis(_step_x, true);
var _hit_y = move_player_axis(_step_y, false);
if (_hit_x) hsp = 0;
if (_hit_y) vsp = 0;
if (_hit_x || _hit_y) {
    is_dashing = false;
    dash_timer = 0;
}

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
