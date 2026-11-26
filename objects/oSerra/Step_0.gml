if (!initialized) {
    initialized = true;

    // Área em que a serra nasceu (ponto de origem dentro do retângulo).
    area = collision_point(x, y, oSerraArea, false, true);
    if (area == noone) area = instance_place(x, y, oSerraArea);

    if (area != noone) {
        var _half_w = (bbox_right - bbox_left) * 0.5;
        var _half_h = (bbox_bottom - bbox_top) * 0.5;

        if (move_axis == "x") {
            min_pos = area.bbox_left + _half_w;
            max_pos = area.bbox_right - _half_w;
        } else {
            // Se a área for menor que a serra (ex.: área bem fina no chão
            // só para marcar a altura), os limites ainda funcionam.
            min_pos = area.bbox_top + _half_h;
            max_pos = area.bbox_bottom - _half_h;
        }
        if (max_pos < min_pos) {
            var _mid = (min_pos + max_pos) * 0.5;
            min_pos = _mid;
            max_pos = _mid;
        }
    }
}

// Desligada: congela no frame parado e não machuca mais.
if (!active) {
    image_index = 0;
    image_speed = 0;
    exit;
}

image_speed = 1;

if (area != noone && move_speed != 0 && max_pos > min_pos) {
    if (move_axis == "x") {
        x += move_speed * move_dir;
        if (x >= max_pos) { x = max_pos; move_dir = -1; }
        else if (x <= min_pos) { x = min_pos; move_dir = 1; }
    } else {
        y += move_speed * move_dir;
        if (y >= max_pos) { y = max_pos; move_dir = -1; }
        else if (y <= min_pos) { y = min_pos; move_dir = 1; }
    }
}

// Contato: dano + knockback (scr_damage_player empurra para longe da serra
// e já respeita os i-frames do jogador).
if (place_meeting(x, y, oPlayer)) {
    scr_damage_player(damage, x);
}
