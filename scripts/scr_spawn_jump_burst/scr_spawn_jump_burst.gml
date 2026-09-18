function scr_spawn_jump_burst(_x, _y, _big) {
    var _b = instance_create_depth(_x, _y, depth, oJumpBurst);
    _b.max_radius = _big ? 34 : 22;
    _b.spike_count = _big ? 14 : 9;
    _b.duration = _big ? 26 : 18;
    _b.timer = _b.duration;
}