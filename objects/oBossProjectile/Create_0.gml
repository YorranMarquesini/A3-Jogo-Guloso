sprite_index = boss1_projectile_spr;
image_xscale = 3;
image_yscale = 3;
visible = true;
depth = -100;

move_spd = 4;

// Mira no player UMA VEZ, no momento que nasce
if (instance_exists(oPlayer)) {
    var _dir = point_direction(x, y, oPlayer.x, oPlayer.y);
    dir_x = lengthdir_x(1, _dir);
    dir_y = lengthdir_y(1, _dir);
} else {
    dir_x = -1; // fallback, caso o player não exista por algum motivo
    dir_y = 0;
}

image_angle = point_direction(0, 0, dir_x, dir_y) + 180;