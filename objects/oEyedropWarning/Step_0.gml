lifetime -= 1;

if (lifetime <= 0) {
    if (instance_exists(target_plat)) {
        var _spawn_x = (target_plat.bbox_left + target_plat.bbox_right) / 2;
        var _spawn_y = target_plat.bbox_top - 300;

        var _eye = instance_create_depth(_spawn_x, _spawn_y, depth, oBossEyeDrop);
        _eye.drop_target_y = target_plat.bbox_top - 20; // ajusta a "altura de pouso" acima da plataforma
    }
    instance_destroy();
}