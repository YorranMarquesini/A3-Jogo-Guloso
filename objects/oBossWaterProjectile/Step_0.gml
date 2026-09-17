// Faz o jato crescer até o máximo, depois conta o tempo ativo
if (image_xscale < max_length) {
    image_xscale += grow_speed;
    if (image_xscale > max_length) {
        image_xscale = max_length;
    }
} else {
    active_time -= 1;
    if (active_time <= 0) {
        instance_destroy();
    }
}

// Rotaciona o jato na direção do jogador
image_angle = dir;

if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.is_invincible) {
        scr_damage_player(1, x);
    }
    instance_destroy();
}