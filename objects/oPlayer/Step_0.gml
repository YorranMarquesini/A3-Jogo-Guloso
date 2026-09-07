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
} else {
    coyote_counter = max(coyote_counter - 1, 0);
}

// --- JUMP BUFFER (sempre atualiza, mesmo durante dash) ---
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
        dash_dir_x = image_xscale; // dash pra frente se não houver input direcional
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
    // --- DURANTE O DASH ---
    dash_timer -= 1;
    hsp = dash_dir_x * dash_speed;
    vsp = dash_dir_y * dash_speed;

    if (dash_timer <= 0) {
        is_dashing = false;
        hsp *= 0.5;
        vsp *= 0.5;
    }

} else {
    // --- MOVIMENTO HORIZONTAL ---
    var _current_acc = _on_ground ? acc : air_acc;

    if (_move != 0) {
        hsp = approach(hsp, _move * move_speed, _current_acc);
        image_xscale = _move; // flipa o sprite conforme a direção
    } else {
        hsp = approach(hsp, 0, _on_ground ? dec : air_acc);
    }

    // --- PULO (normal + coyote + double jump) ---
    if (jump_buffer_counter > 0) {
        if (coyote_counter > 0) {
            vsp = jump_force;
            jump_count = 1;
            jump_buffer_counter = 0;
            coyote_counter = 0;
        } else if (jump_count < max_jumps) {
            vsp = jump_force * 0.9;
            jump_count += 1;
            jump_buffer_counter = 0;
        }
    }

    // --- PULO VARIÁVEL (corta o impulso se soltar o botão) ---
    if (_jump_released && vsp < 0) {
        vsp *= jump_cut_multiplier;
    }

    // --- GRAVIDADE ---
    vsp = min(vsp + grav, max_fall);
}

// ============================
// COLISÃO (sempre roda, dash ou não)
// ============================

// Horizontal
if (place_meeting(x + hsp, y, oGround)) {
    while (!place_meeting(x + sign(hsp), y, oGround)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Vertical
if (place_meeting(x, y + vsp, oGround)) {
    while (!place_meeting(x, y + sign(vsp), oGround)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;