// ============================================================
//  TAMPA — o projétil que a Garrafa cospe.
//  Mira no player UMA VEZ, no frame em que nasce
//  (mesma ideia do oBossProjectile).
// ============================================================

depth = -100;

image_speed = 1;   // o sprite tem 2 frames: a tampa girando
image_index = 0;

move_spd = 7;      // quem atira pode sobrescrever
dano     = 1;
dono     = noone;  // quem atirou (pra não se acertar, se um dia precisar)

if (instance_exists(oPlayer)) {
    // mira no CENTRO do player, não na origem do sprite dele
    var _alvo_x = (oPlayer.bbox_left + oPlayer.bbox_right) * 0.5;
    var _alvo_y = (oPlayer.bbox_top  + oPlayer.bbox_bottom) * 0.5;

    var _dir = point_direction(x, y, _alvo_x, _alvo_y);
    dir_x = lengthdir_x(1, _dir);
    dir_y = lengthdir_y(1, _dir);
} else {
    dir_x = -1;   // sem player na sala, só sai voando pra esquerda
    dir_y = 0;
}
