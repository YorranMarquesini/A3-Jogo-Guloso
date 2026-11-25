var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _elapsed = (current_time - start_ms) / 1000;
var _unit = min(_w / 1366, _h / 768);

gpu_set_texfilter(false);
gpu_set_blendmode(bm_normal);
draw_set_colour(c_white);
draw_set_alpha(1);

if (room != rm_menu) {
    var _fade = clamp((_elapsed - 0.15) / 0.65, 0, 1)
              * clamp((3.55 - _elapsed) / 0.55, 0, 1);
    var _cx = _w * 0.5;
    var _cy = _h * 0.42;

    draw_set_colour(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    for (var _i = 0; _i < 36; _i++) {
        var _px = (_i * 199) mod _w;
        var _py = (_i * 83 + _h * 2 - _elapsed * (17 + (_i mod 4) * 10)) mod _h;
        var _size = max(1, round(_unit * (2 + (_i mod 3))));
        draw_set_alpha(_fade * (0.17 + 0.16 * sin(_i + _elapsed * 4)));
        draw_set_colour((_i mod 3 == 0) ? make_color_rgb(240, 194, 101) : make_color_rgb(113, 212, 126));
        draw_rectangle(floor(_px), floor(_py), floor(_px) + _size, floor(_py) + _size, false);
    }

    draw_set_alpha(1);
    if (sprite_exists(logo_sprite)) {
        var _scale = min(_w * 0.31 / sprite_get_width(logo_sprite),
                         _h * 0.40 / sprite_get_height(logo_sprite));
        _scale *= 0.88 + 0.12 * clamp(_elapsed / 1.3, 0, 1);
        draw_sprite_ext(logo_sprite, 0, _cx, _cy, _scale, _scale, 0, c_white, _fade);
    }

    var _label_y = _h * 0.70;
    draw_set_alpha(_fade);
    draw_set_colour(make_color_rgb(236, 222, 172));
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_cx, _label_y, "SIGMA ROOM", 1.45 * _unit, 1.45 * _unit, 0);
    draw_set_colour(make_color_rgb(103, 171, 102));
    draw_rectangle(_cx - 105 * _unit, _label_y + 35 * _unit,
                   _cx + 105 * _unit, _label_y + 37 * _unit, false);
} else {
    // O menu ja esta sendo desenhado por baixo desta camada.
    var _take = max(0, _elapsed - 3.55);
    var _reveal = clamp((_take - 2.05) / 2.55, 0, 1);
    var _ease = _reveal * _reveal * (3 - 2 * _reveal);
    draw_set_alpha(1 - _ease);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_alpha(1);

    if (video_started) {
        var _frame = video_draw();
        if (array_length(_frame) > 1 && _frame[0] == 0 && surface_exists(_frame[1])) {
            if (!surface_exists(video_snapshot)) {
                video_snapshot = surface_create(surface_get_width(_frame[1]), surface_get_height(_frame[1]));
            }
            if (surface_exists(video_snapshot)) surface_copy(video_snapshot, 0, 0, _frame[1]);
        }
    }

    if (surface_exists(video_snapshot)) {
        var _sw = surface_get_width(video_snapshot);
        var _sh = surface_get_height(video_snapshot);
        var _scale = min(_w / _sw, _h / _sh) * lerp(1, 0.24, _ease);
        var _vw = _sw * _scale;
        var _vh = _sh * _scale;
        var _cx = lerp(_w * 0.5, _w * 0.835, _ease);
        var _cy = lerp(_h * 0.5, _h * 0.48, _ease);
        var _opacity = clamp(_take / 0.35, 0, 1) * (1 - clamp((_reveal - 0.32) / 0.60, 0, 1));
        draw_set_alpha(_opacity);
        draw_surface_stretched(video_snapshot, _cx - _vw / 2, _cy - _vh / 2, _vw, _vh);

        // Os pixels do gesto se espalham e somem sobre a paisagem real.
        var _scatter = sin(_reveal * pi);
        for (var _i = 0; _i < 30; _i++) {
            var _a = _i * 137.5 + _ease * 30;
            var _r = (19 + (_i mod 9) * 12) * _unit * (0.5 + _ease);
            var _px = floor(_cx + lengthdir_x(_r, _a));
            var _py = floor(_cy + lengthdir_y(_r * 0.65, _a));
            var _size = max(1, round(_unit * (2 + (_i mod 3))));
            draw_set_alpha(_scatter * (0.32 + (_i mod 3) * 0.15));
            draw_set_colour((_i mod 4 == 0) ? make_color_rgb(242, 213, 132) : make_color_rgb(122, 239, 134));
            draw_rectangle(_px, _py, _px + _size, _py + _size, false);
        }
    }
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
