if (state != "cutscene" && state != "dying") {
    var _w = 560;
    var _h = 22;
    var _x = (display_get_gui_width() - _w) * 0.5;
    var _y = 36;
    var _pct = clamp(hp / max_hp, 0, 1);

    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_x - 4, _y - 4, _x + _w + 4, _y + _h + 4, false);
    draw_set_color(make_color_rgb(135, 15, 12));
    draw_rectangle(_x, _y, _x + _w * _pct, _y + _h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogo);
    draw_text(display_get_gui_width() * 0.5, _y - 6, (phase == 2) ? "CAGLIOSTRO - FASE 2" : "CAGLIOSTRO");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (finale_stage == "blast") {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _p = 1 - clamp(final_explosion_timer / final_explosion_duration, 0, 1);
    var _cx = _gw * 0.72;
    var _cy = _gh * 0.50;
    draw_set_alpha(max(0, 0.94 - _p * 1.25));
    draw_set_colour(c_white);
    draw_rectangle(0, 0, _gw, _gh, false);
    for (var _r = 0; _r < 9; _r++) {
        var _radius = max(0, (_p * 980) - _r * 54);
        draw_set_alpha(max(0, (1 - _p) * (0.60 - _r * 0.045)));
        draw_set_colour(choose(c_white, c_yellow, c_orange, make_color_rgb(75, 255, 150)));
        draw_circle(_cx, _cy, _radius, true);
    }
    draw_set_alpha(clamp((_p - 0.68) / 0.32, 0, 1));
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    draw_set_colour(c_white);
}

if (state == "dying" && (finale_stage == "qte" || finale_stage == "rhythm" || finale_stage == "score" || finale_stage == "defeat")) {
    var _w = display_get_gui_width(), _h = display_get_gui_height();
    var _cx = _w * 0.5, _cy = _h * 0.49;
    var _gold = make_color_rgb(255, 197, 83);
    var _green = make_color_rgb(114, 248, 181);
    var _red = make_color_rgb(255, 100, 86);
    draw_set_alpha(finale_stage == "defeat" ? 0.86 : 0.18);
    draw_set_color(make_color_rgb(11, 17, 21));
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_alpha(1);
    if (finale_stage == "rhythm" || finale_stage == "score" || finale_stage == "qte") {
        var _cam = view_camera[0];
        var _vx = camera_get_view_x(_cam), _vy = camera_get_view_y(_cam);
        var _sx = _w / camera_get_view_width(_cam), _sy = _h / camera_get_view_height(_cam);
        var _bx = clamp((x - _vx) * _sx, 0, _w);
        var _by = clamp((y - _vy) * _sy, _h * 0.12, _h * 0.90);
        var _px = instance_exists(oPlayer) ? (oPlayer.x - _vx) * _sx : _w * 0.2;
        var _py = instance_exists(oPlayer) ? (oPlayer.y - oPlayer.visual_float_height - _vy) * _sy : _h * 0.60;
        var _clock = clash_age;
        // O recuo abre espaco para as duas frentes mesmo se o golpe final foi corpo a corpo.
        var _opening = clamp(_clock * 2.5, 0, 1);
        var _side = _px <= _bx ? 1 : -1;
        _bx = lerp(_bx, _w * (_side > 0 ? 0.82 : 0.18), _opening);
        _px = lerp(_px, _w * (_side > 0 ? 0.18 : 0.82), _opening);
        var _ix = lerp(_px, _bx, clash_front), _iy = lerp(_py, _by, clash_front);
        var _power = finale_stage == "qte" ? 0.6 : min(1, 0.16 + _clock * 2.3);
        gpu_set_blendmode(bm_add);
        for (var _team = 0; _team < 2; _team++) {
            if (_team == 0 && finale_stage == "qte") continue;
            var _ox = _team == 0 ? _px : _bx, _oy = _team == 0 ? _py : _by;
            var _color = _team == 0 ? make_color_rgb(37, 225, 139) : make_color_rgb(249, 72, 19);
            var _hot = _team == 0 ? make_color_rgb(173, 255, 213) : make_color_rgb(255, 196, 70);
            var _speed = _team == 0 ? 1.28 : 1.07;
            var _time = finale_stage == "qte" ? finale_time : _clock;
            var _reach = finale_stage == "qte" ? 0.16 : _opening;
            for (var j = 0; j < 30; j++) {
                var _p = frac(_time * _speed + j / 30);
                var _phase = j * 2.4 + _time * 5;
                var _spread = _h * (0.025 + 0.07 * sin(pi * _p)) * _power;
                var _xx = lerp(_ox, _ix, _p * _reach) + cos(_phase) * _spread * 0.32;
                var _yy = lerp(_oy, _iy, _p * _reach) + sin(_phase) * _spread;
                var _size = _h * (0.022 + 0.052 * (1 - _p)) * _power;
                draw_set_alpha(0.65);
                draw_circle_color(_xx, _yy, _size * 1.85, _color, c_black, false);
                draw_circle_color(_xx, _yy, _size, _hot, c_black, false);
            }
            for (var j = 0; j < 3; j++) {
                var _wave = frac(_time * 1.6 + j / 3);
                draw_set_alpha(0.75 * (1 - _wave));
                draw_set_color(_hot);
                draw_circle(_ox, _oy, _h * (0.025 + 0.16 * _wave) * _power, true);
            }
        }
        if (finale_stage != "qte") {
            draw_set_alpha(_opening);
            draw_circle_color(_ix, _iy, _h * (0.07 + 0.02 * sin(_clock * 32)), c_white, c_black, false);
            for (var i = 0; i < 15; i++) {
                var _p = frac(_clock * 1.8 + i / 15);
                var _angle = i * 137.5;
                var _dist = _p * _h * 0.23;
                draw_set_alpha(_opening * (1 - _p));
                draw_line_width_color(_ix + lengthdir_x(_dist, _angle), _iy + lengthdir_y(_dist, _angle),
                    _ix + lengthdir_x(_dist + 11, _angle), _iy + lengthdir_y(_dist + 11, _angle), 2, c_white, _gold);
            }
        }
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
    draw_set_font(fnt_tutoras);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (finale_stage == "qte") {
        var _remaining = clamp(1 - finale_time / finale_qte_window, 0, 1);
        var _r = _h * (0.10 + 0.17 * _remaining);
        draw_set_color(_gold);
        draw_circle(_cx, _cy, _r, true);
        draw_circle(_cx, _cy, _r + 3, true);
        draw_set_color(_red);
        draw_circle(_cx, _cy, _h * 0.10, true);
        draw_set_color(c_white);
        draw_text_transformed(_cx, _cy, controls_label(finale_qte_action), 2, 2, 0);
        draw_text(_cx, _h * 0.16, "QUEBRE A ONDA");
        draw_set_font(fnt_dialogo);
        draw_text(_cx, _h * 0.79, "APERTE AGORA");
    } else if (finale_stage == "rhythm") {
        if (finale_note < array_length(finale_chart)) {
            var _until = finale_cues[finale_note] - finale_time;
            if (_until <= 0.85) {
                var _action = finale_actions[finale_chart[finale_note]];
                var _label = controls_label(_action);
                var _y = _h * 0.29;
                var _r = max(31, string_width(_label) * 0.5 + 10);
                draw_set_alpha(0.86);
                draw_set_color(make_color_rgb(16, 24, 31));
                draw_circle(_cx, _y, _r, false);
                draw_set_alpha(1);
                draw_set_color(abs(_until) <= finale_hit_window ? _green : _gold);
                draw_circle(_cx, _y, _r, true);
                var _ring = _r + max(0, _until) / 0.85 * _h * 0.09;
                draw_circle(_cx, _y, _ring, true);
                draw_circle(_cx, _y, _ring + 1, true);
                draw_set_color(c_white);
                draw_text(_cx, _y, _label);
            }
        }
    } else if (finale_stage == "score") {
        // As duas ondas mostram o resultado invadindo o lado derrotado.
    } else {
        draw_set_color(_red);
        draw_text_transformed(_cx, _cy, "ESPIRITO DISPERSO", 1.6, 1.6, 0);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

