var _camera = view_camera[0];
if (_camera < 0) exit;

var _vx = camera_get_view_x(_camera);
var _vy = camera_get_view_y(_camera);
var _vw = camera_get_view_width(_camera);
var _vh = camera_get_view_height(_camera);
var _pan_x = clamp(_vx / max(1, room_width - _vw), 0, 1) - 0.5;
var _pan_y = clamp(_vy / max(1, room_height - _vh), 0, 1) - 0.5;
var _prior_filter = gpu_get_texfilter();
gpu_set_texfilter(false);

for (var _layer = 0; _layer < 2; _layer++) {
    var _sprite = _layer == 0 ? spr_fac_back : spr_fac_back1;
    var _travel_x = _vw * (_layer == 0 ? 0.22 : 0.58);
    var _travel_y = _vh * (_layer == 0 ? 0.10 : 0.30);
    var _drift = _layer == 0 ? 0 : sin(current_time * 0.00045) * 18;
    var _sw = sprite_get_width(_sprite);
    var _sh = sprite_get_height(_sprite);
    var _scale = max((_vw + _travel_x + 40) / _sw, (_vh + _travel_y) / _sh);
    var _dw = _sw * _scale;
    var _dh = _sh * _scale;
    var _px = round(_vx + (_vw - _dw) * 0.5 - _pan_x * _travel_x + _drift);
    var _py = round(_vy + (_vh - _dh) * 0.5 - _pan_y * _travel_y);
    draw_sprite_ext(_sprite, 0, _px, _py, _scale, _scale, 0, c_white, _layer == 0 ? 1 : 0.40);
}

gpu_set_texfilter(_prior_filter);
