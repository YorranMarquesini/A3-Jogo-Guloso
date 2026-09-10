if (instance_exists(target)) {
    var _target_x = target.x - cam_width / 2;
    var _target_y = target.y - cam_height / 2;

    cam_x = lerp(cam_x, _target_x, lerp_factor);
    cam_y = lerp(cam_y, _target_y, lerp_factor);

    // Trava a câmera dentro dos limites do room (estilo Cuphead/metroidvania)
    cam_x = clamp(cam_x, 0, room_width - cam_width);
    cam_y = clamp(cam_y, 0, room_height - cam_height);

    camera_set_view_pos(camera, cam_x, cam_y);
}