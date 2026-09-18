// --- COR/PISCAR DO PLAYER ---
if (is_invincible) {
    image_blend = c_aqua; // invencibilidade do dash
} else if (hp_invuln_timer > 0) {
    image_blend = (hp_invuln_timer div 4) % 2 == 0 ? c_white : c_red;
} else {
    image_blend = c_white;
}

// ============================
// CORPO ESPECTRAL (tornado verde) — versão turbinada
// ============================
var _spirit_x = x;
var _spirit_base_y = y + 4;
var _spirit_height = 46; // altura total do redemoinho, do chão até quase a cabeça

var _swirl_layers = 9;
for (var _i = 0; _i < _swirl_layers; _i++) {
    var _t = _i / _swirl_layers; // 0 (base) até quase 1 (topo)

    // Afunila conforme sobe (mais largo embaixo, fino em cima — forma de cone)
    var _layer_radius = lerp(14, 2, _t);
    var _layer_y = _spirit_base_y - (_t * _spirit_height);

    // Espiral girando: cada camada roda mais rápido/desfasada que a de baixo
    var _spin = current_time / 4 + (_i * 50);
    var _wobble_x = lengthdir_x(2 + _t * 4, _spin);

    // Pulsa levemente o alpha pra dar sensação de "energia viva"
    var _pulse = 0.25 + 0.15 * sin(current_time / 90 + _i);

    draw_set_alpha(_pulse * (1 - _t * 0.3));
    draw_set_color(merge_color(c_lime, c_aqua, _t));
    draw_ellipse(
        _spirit_x - _layer_radius + _wobble_x, _layer_y - _layer_radius * 0.4,
        _spirit_x + _layer_radius + _wobble_x, _layer_y + _layer_radius * 0.4,
        false
    );
}
draw_set_alpha(1);

// --- PARTÍCULAS DE ENERGIA ORBITANDO (poeira sendo puxada pro vórtice) ---
var _orbit_particles = 6;
for (var _p = 0; _p < _orbit_particles; _p++) {
    var _p_t = ((_p / _orbit_particles) + (current_time / 900)) mod 1; // sobe continuamente e recicla
    var _p_radius = lerp(16, 1, _p_t);
    var _p_y = _spirit_base_y - (_p_t * _spirit_height);
    var _p_spin = current_time / 3 + (_p * 137); // ângulos bem espalhados

    var _px = _spirit_x + lengthdir_x(_p_radius, _p_spin);
    var _py = _p_y;

    var _p_alpha = (1 - _p_t) * 0.9;
    draw_set_alpha(_p_alpha);
    draw_set_color(_p mod 2 == 0 ? c_lime : c_aqua);
    draw_circle(_px, _py, 2, false);
}
draw_set_alpha(1);
draw_set_color(c_white);

// --- CABEÇA FLUTUANDO (bob suave + altura fixa acima do "pé" real) ---
var _bob_y = sin(spirit_bob_timer) * spirit_bob_height;
var _head_draw_y = y - visual_float_height + _bob_y;

draw_sprite_ext(sprite_index, image_index, x, _head_draw_y, image_xscale, image_yscale, 0, image_blend, image_alpha);

// ============================
// ARMA COM TELECINESE
// ============================
if (has_weapon && weapon_sprite != noone && (is_attacking || is_heavy_attacking || is_throwing)) {
    var _dir = (facing == "right") ? 1 : -1;
    var _push = is_throwing ? 0 : telekinesis_push_x; // sem empurrão extra durante o arremesso

    var _weapon_x = x + ((weapon_offset_x + _push) * _dir);
    var _weapon_y = y + weapon_offset_y + _bob_y;

    var _draw_sprite = weapon_sprite;
    var _draw_index = 0;
    var _draw_angle = weapon_angle;

    if (is_heavy_attacking && weapon_type == "tesoura") {
        var _sweep_progress = 1 - (heavy_attack_timer / sweep_duration);
        var _swing_reach = sin(_sweep_progress * pi) * sweep_extra_reach;
        _weapon_x = x + ((weapon_offset_x + _push + _swing_reach) * _dir); // soma a telecinese ao arco do swep
    }

    if (is_throwing && weapon_type == "arpao") {
        var _shot_progress = 1 - (throw_anim_timer / throw_anim_duration);
        var _frame_count = sprite_get_number(arpaoShot_spr);

        _draw_sprite = arpaoShot_spr;
        _draw_index = clamp(floor(_shot_progress * _frame_count), 0, _frame_count - 1);
        _draw_angle = -40;
        _weapon_y = y + (-30) + _bob_y; // offset local, não mexe na variável global weapon_offset_y
    }

    // --- AURA DE TELECINESE (não aparece durante o arremesso em si) ---
    if (!is_throwing) {
        draw_set_alpha(0.25);
        draw_set_color(c_aqua);
        draw_circle(_weapon_x, _weapon_y, telekinesis_orbit_radius, false);
        draw_set_alpha(1);

        var _orbit_count = 3;
        for (var _o = 0; _o < _orbit_count; _o++) {
            var _o_ang = telekinesis_angle + (_o * (360 / _orbit_count));
            var _ox = _weapon_x + lengthdir_x(telekinesis_orbit_radius, _o_ang);
            var _oy = _weapon_y + lengthdir_y(telekinesis_orbit_radius, _o_ang) * 0.5;

            draw_set_alpha(0.8);
            draw_set_color(c_lime);
            draw_circle(_ox, _oy, 3, false);
        }
        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    draw_sprite_ext(
        _draw_sprite, _draw_index,
        _weapon_x, _weapon_y,
        _dir, 1,
        _draw_angle * _dir,
        c_white, 1
    );
}