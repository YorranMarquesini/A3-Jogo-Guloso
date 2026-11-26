var _player = instance_place(x, y, oPlayer);
if (_player != noone && !instance_exists(oGameOver)) {
    _player.hp = 0;
    instance_create_depth(0, 0, -9999, oGameOver);
}
