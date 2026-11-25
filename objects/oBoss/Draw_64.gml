var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (final_explosion_started) {
    var _cam = view_camera[0];
    var _vx = camera_get_view_x(_cam);
    var _vy = camera_get_view_y(_cam);
    var _vw = camera_get_view_width(_cam);
    var _vh = camera_get_view_height(_cam);
    var _bx = (x - _vx) * (_gw / _vw);
    var _by = (y - _vy) * (_gh / _vh);
    var _elapsed = 80 - final_explosion_timer;

    // Flash inicial, depois aneis de choque que atravessam a arena.
    draw_set_alpha(max(0, 1 - _elapsed / 13));
    draw_set_colour(c_white);
    draw_rectangle(0, 0, _gw, _gh, false);

    for (var _shock = 0; _shock < 4; _shock++) {
        var _age = max(0, _elapsed - _shock * 7);
        var _shock_alpha = clamp(1 - _age / 50, 0, 1) * 0.65;
        draw_set_alpha(_shock_alpha);
        draw_set_colour(choose(c_white, c_aqua, c_yellow));
        draw_circle(_bx, _by, _age * (9 + _shock * 1.5), true);
        draw_circle(_bx, _by, _age * (9 + _shock * 1.5) + 5, true);
    }

    // Fecha em preto apenas nos ultimos frames, preparando a cutscene.
    draw_set_alpha(clamp((12 - final_explosion_timer) / 12, 0, 1));
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
    exit;
}

if (state == "dying") exit;

var _cx = _gw * 0.5;
var _bar_w = min(590, _gw * 0.56);
var _bar_h = 24;
var _x1 = _cx - _bar_w * 0.5;
var _y1 = 34;
var _max_hp = (phase == 1) ? phase1_max_hp : phase2_max_hp;
var _pct = clamp(hp / max(1, _max_hp), 0, 1);
var _fill = _bar_w * _pct;
var _accent = (phase == 1) ? make_color_rgb(88, 184, 83) : make_color_rgb(80, 176, 205);

// Barra de madeira e musgo, coerente com a arena natural.
draw_set_alpha(0.95);
draw_set_colour(make_color_rgb(24, 17, 12));
draw_rectangle(_x1 - 12, _y1 - 12, _x1 + _bar_w + 12, _y1 + _bar_h + 12, false);
draw_set_colour(make_color_rgb(91, 62, 35));
draw_rectangle(_x1 - 7, _y1 - 7, _x1 + _bar_w + 7, _y1 + _bar_h + 7, false);
draw_set_colour(make_color_rgb(31, 27, 20));
draw_rectangle(_x1, _y1, _x1 + _bar_w, _y1 + _bar_h, false);
draw_set_colour(_accent);
draw_rectangle(_x1, _y1, _x1 + _fill, _y1 + _bar_h, false);
draw_set_colour(merge_color(_accent, c_white, 0.42));
draw_rectangle(_x1 + 3, _y1 + 3, _x1 + max(3, _fill - 3), _y1 + 7, false);

// Marcas de madeira dão leitura em quartos sem parecer HUD moderno.
draw_set_colour(make_color_rgb(49, 35, 23));
for (var _i = 1; _i < 4; _i++) {
    var _notch = _x1 + (_bar_w * _i / 4);
    draw_rectangle(_notch - 2, _y1, _notch + 2, _y1 + _bar_h, false);
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
