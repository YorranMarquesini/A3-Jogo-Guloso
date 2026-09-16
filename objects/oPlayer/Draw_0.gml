// --- COR DO PLAYER (feedback visual de invencibilidade) ---
if (is_invincible) {
    image_blend = c_aqua;
} else {
    image_blend = c_white;
}

// Desenha o player normalmente
draw_self();

// Desenha a arma SÓ durante o ataque
if (has_weapon && weapon_sprite != noone && is_attacking) {
    var _dir = (facing == "right") ? 1 : -1;

    var _weapon_x = x + (weapon_offset_x * _dir);
    var _weapon_y = y + weapon_offset_y;

    draw_sprite_ext(
        weapon_sprite,
        0,
        _weapon_x,
        _weapon_y,
        _dir,
        1,
        weapon_angle * _dir,
        c_white,
        1
    );
}

// Faz o personagem piscar em vermelho/transparente quando estiver invencível
if (invuln_timer > 0 && (invuln_timer div 4) mod 2 == 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 0.6);
} else {
    draw_self(); // Desenho normal do jogador
}