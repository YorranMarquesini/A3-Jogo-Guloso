draw_self();
if (belt_speed == 0) exit;

// Todas as pecas usam o mesmo relogio e um ciclo de 16 px.
// A arte das pontas fica fixa, e os reflexos correm sobre os roletes.
var _phase = floor(current_time * abs(belt_speed) * 0.045) mod 16;
if (belt_speed < 0) _phase = (16 - _phase) mod 16;
var _first = sprite_index == sp_transporter ? 6 : 0;
var _last = sprite_index == spr_trasporter3 ? 122 : 128;
var _axis_x = lengthdir_x(image_xscale, image_angle);
var _axis_y = lengthdir_y(image_xscale, image_angle);
var _offset_x = lengthdir_x(9 * image_yscale, image_angle - 90);
var _offset_y = lengthdir_y(9 * image_yscale, image_angle - 90);
var _old_color = draw_get_colour();
var _old_alpha = draw_get_alpha();
draw_set_colour(make_color_rgb(255, 140, 122));
draw_set_alpha(image_alpha * 0.7);
for (var _mark = _phase - 16; _mark < _last; _mark += 16) {
    var _left = max(_first, _mark);
    var _right = min(_last, _mark + 3);
    if (_right <= _left) continue;
    draw_line(x + _offset_x + _left * _axis_x, y + _offset_y + _left * _axis_y,
              x + _offset_x + _right * _axis_x, y + _offset_y + _right * _axis_y);
}
draw_set_alpha(_old_alpha);
draw_set_colour(_old_color);
