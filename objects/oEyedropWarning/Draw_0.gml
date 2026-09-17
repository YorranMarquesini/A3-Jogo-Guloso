if (instance_exists(target_plat)) {
    var _x1 = target_plat.bbox_left;
    var _x2 = target_plat.bbox_right;
    var _y2 = target_plat.bbox_top;
    var _y1 = _y2 - 50;

    var _alpha = 0.3 + 0.3 * abs(sin(current_time / 80)); // pisca

    draw_set_alpha(_alpha);
    draw_set_color(c_red);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
	depth = -60;
}