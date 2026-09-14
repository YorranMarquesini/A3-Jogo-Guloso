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