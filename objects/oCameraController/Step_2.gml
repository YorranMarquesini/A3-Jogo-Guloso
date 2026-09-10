if (instance_exists(target))
{
    var _cam_x = target.x - cam_width * 0.5;
    var _cam_y = target.y - cam_height * 0.5;

    _cam_x = clamp(
        _cam_x,
        0,
        max(0, room_width - cam_width)
    );

    _cam_y = clamp(
        _cam_y,
        0,
        max(0, room_height - cam_height)
    );

    _cam_x = floor(_cam_x);
    _cam_y = floor(_cam_y);

    camera_set_view_pos(
        camera,
        _cam_x,
        _cam_y
    );
}