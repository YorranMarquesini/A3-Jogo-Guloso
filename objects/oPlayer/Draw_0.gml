// --- COR/PISCAR DO PLAYER ---
if (is_invincible) {
    image_blend = c_aqua; // invencibilidade do dash
} else if (hp_invuln_timer > 0) {
    // Pisca durante i-frames de dano
    image_blend = (hp_invuln_timer div 4) % 2 == 0 ? c_white : c_red;
} else {
    image_blend = c_white;
}

// Desenha o player normalmente
draw_self();

// Desenha a arma SÓ durante o ataque
if (has_weapon && weapon_sprite != noone && (is_attacking || is_heavy_attacking || is_throwing)) {
    var _dir = (facing == "right") ? 1 : -1;
    var _weapon_x = x + (weapon_offset_x * _dir);
    var _weapon_y = y + weapon_offset_y;

    var _draw_sprite = weapon_sprite;
    var _draw_index = 0;
    var _draw_angle = weapon_angle;
	
	if (is_heavy_attacking && weapon_type == "tesoura") {
		var _sweep_progress = 1 - (heavy_attack_timer / sweep_duration);
		var _swing_reach = sin(_sweep_progress * pi) * sweep_extra_reach;
		_weapon_x = x + (weapon_offset_x + _swing_reach) * _dir;
		}

    if (is_throwing && weapon_type == "arpao") {
        var _shot_progress = 1 - (throw_anim_timer / throw_anim_duration);
        var _frame_count = sprite_get_number(arpaoShot_spr);

        _draw_sprite = arpaoShot_spr;
        _draw_index = clamp(floor(_shot_progress * _frame_count), 0, _frame_count - 1);
        _draw_angle = -40;
		weapon_offset_y = -30;
    }

    draw_sprite_ext(
        _draw_sprite, _draw_index,
        _weapon_x, _weapon_y,
        _dir, 1,
        _draw_angle * _dir,
        c_white, 1
    );
}