if (keyboard_check_pressed(fullscreen_key)) {
    window_set_fullscreen(!window_get_fullscreen());
}

// Recalcula a escala inteira toda vez (funciona tanto em janela quanto fullscreen)
var _mon_w = window_get_width();
var _mon_h = window_get_height();

var _scale = min(floor(_mon_w / base_width), floor(_mon_h / base_height));
_scale = max(_scale, 1);

var _port_w = base_width * _scale;
var _port_h = base_height * _scale;

var _off_x = (_mon_w - _port_w) / 2;
var _off_y = (_mon_h - _port_h) / 2;

view_set_wport(0, _port_w);
view_set_hport(0, _port_h);
view_set_xport(0, _off_x);
view_set_yport(0, _off_y);