var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (phase_name == "video") {
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_color(c_white);

    var _frame = video_draw();
    if (_frame[0] == -2) video_finished = true;
    if (_frame[0] == 0 && array_length(_frame) > 1 && surface_exists(_frame[1])) {
        var _width = surface_get_width(_frame[1]);
        var _height = surface_get_height(_frame[1]);
        var _scale = min(_gw / _width, _gh / _height);
        var _dw = _width * _scale;
        var _dh = _height * _scale;
        draw_surface_stretched(_frame[1], (_gw - _dw) * 0.5, (_gh - _dh) * 0.5, _dw, _dh);
    }
    exit;
}

if (black_alpha > 0) {
    draw_set_alpha(black_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
}

if (glow_alpha > 0 && instance_exists(boss)) {
    var _cam = view_camera[0];
    var _sx = _gw / camera_get_view_width(_cam);
    var _sy = _gh / camera_get_view_height(_cam);
    // Centro do brilho no charuto, inclusive com o boss ampliado na room.
    var _cigar_x = boss.x - (20 * abs(boss.image_xscale));
    var _cigar_y = boss.y + (9 * abs(boss.image_yscale));
    var _gx = (_cigar_x - camera_get_view_x(_cam)) * _sx;
    var _gy = (_cigar_y - camera_get_view_y(_cam)) * _sy;
    for (var _r = 90; _r >= 12; _r -= 10) {
        draw_set_alpha(glow_alpha * (1 - _r / 105) * 0.35);
        draw_set_color(make_color_rgb(255, 25, 5));
        draw_circle(_gx, _gy, _r, false);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
