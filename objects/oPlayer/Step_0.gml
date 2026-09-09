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
var _move = _right - _left;

// --- GROUND CHECK ---
var _on_ground = place_meeting(x, y+1, oGround);

if (_on_ground) {
    coyote_counter = coyote_time;
    jump_count = 0;
    can_dash = true;
    wall_jump_used_dir = 0;
} else {
    coyote_counter = max(coyote_counter - 1, 0);
}

// --- WALL CHECK ---
var _wall_right = place_meeting(x + wall_check_dist, y, oGround);
var _wall_left = place_meeting(x - wall_check_dist, y, oGround);

if (_wall_right) {
    wall_dir = 1;
} else if (_wall_left) {
    wall_dir = -1;
} else {
    wall_dir = 0;
}

var _touching_wall = (wall_dir != 0 && !_on_ground);
var _new_wall_contact = (_touching_wall && !wall_touch_prev);

is_wall_sliding = (!_on_ground && wall_dir != 0 && vsp > 0 && !is_dashing &&
    ((wall_dir == 1 && _right) || (wall_dir == -1 && _left)));

if (wall_dir != 0 && !_on_ground) {
    wall_coyote_counter = wall_coyote_time;
} else {
    wall_coyote_counter = max(wall_coyote_counter - 1, 0);
}

// Só reseta dash/double jump em contato NOVO com parede DIFERENTE da última usada
if (_new_wall_contact && wall_dir != wall_jump_used_dir) {
    can_dash = true;
    jump_count = 0;
}

wall_touch_prev = _touching_wall;

// --- JUMP BUFFER ---
if (_jump_pressed) {
    jump_buffer_counter = jump_buffer;
} else {
    jump_buffer_counter = max(jump_buffer_counter - 1, 0);
}

// --- DASH COOLDOWN ---
if (dash_cooldown > 0) {
    dash_cooldown -= 1;
}

// --- INICIA O DASH ---
if (_dash_pressed && can_dash && dash_cooldown <= 0 && !is_dashing) {
    is_dashing = true;
    can_dash = false;
    dash_timer = dash_time;
    dash_cooldown = dash_cooldown_max;

    var _dx = _right - _left;
    var _dy = _down - _up;

    if (_dx == 0 && _dy == 0) {
        dash_dir_x = image_xscale;
        dash_dir_y = 0;
    } else {
        var _len = point_distance(0, 0, _dx, _dy);
        dash_dir_x = _dx / _len;
        dash_dir_y = _dy / _len;
    }
}

// ============================
// LÓGICA PRINCIPAL
// ============================
if (is_dashing) {
    dash_timer -= 1;
    hsp = dash_dir_x * dash_speed;
    vsp = dash_dir_y * dash_speed;

    if (place_meeting(x + hsp, y, oGround)) {
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
        hsp = approach(hsp, _move * move_speed, air_acc * 0.3);
    } else if (_move != 0) {
        hsp = approach(hsp, _move * move_speed, _current_acc);
        image_xscale = _move;
    } else {
        hsp = approach(hsp, 0, _on_ground ? dec : air_acc);
    }

    // --- PULO ---
    if (jump_buffer_counter > 0) {
        if (coyote_counter > 0) {
            vsp = jump_force;
            jump_count = 1;
            jump_buffer_counter = 0;
            coyote_counter = 0;

        } else if (wall_coyote_counter > 0 && wall_dir != 0 && wall_dir != wall_jump_used_dir) {
            vsp = wall_jump_force_y;

            if (_move == -wall_dir) {
                hsp = -wall_dir * wall_jump_force_x;
                image_xscale = -wall_dir;
            } else {
                hsp = 0;
            }

            jump_count = max_jumps; // <<< AQUI: consome TODOS os pulos, não deixa sobrar double jump
            jump_buffer_counter = 0;
            wall_coyote_counter = 0;
            wall_jump_lock = wall_jump_lock_time;
            wall_jump_used_dir = wall_dir;

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
    if (is_wall_sliding) {
        vsp = min(vsp + grav, wall_slide_speed);
    } else {
        vsp = min(vsp + grav, max_fall);
    }
}

// ============================
// COLISÃO
// ============================
if (place_meeting(x + hsp, y, oGround)) {
    while (!place_meeting(x + sign(hsp), y, oGround)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, oGround)) {
    while (!place_meeting(x, y + sign(vsp), oGround)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;