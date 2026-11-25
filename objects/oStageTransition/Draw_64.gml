var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _cx = _w * 0.5;
var _cy = _h * 0.5;

gpu_set_texfilter(false);
draw_set_alpha(1);
draw_set_colour(c_white);

if (stage_transition_type == 1) {
    // Antes da troca de room, a camera atravessa floresta e lago. Depois da
    // troca, a agua se recolhe e revela a Fase 1 ja carregada.
    if (!room_switched) {
        var _t = clamp(timer / duration_out, 0, 1);

        // O tutorial desaparece por um portal de folhas, sem corte seco.
        var _opening = clamp(timer / 42, 0, 1);
        draw_set_alpha(_opening * 0.94);
        draw_rectangle_color(0, 0, _w, _h,
            make_color_rgb(2, 12, 8), make_color_rgb(8, 37, 19),
            make_color_rgb(1, 7, 6), make_color_rgb(3, 25, 20), false);

        // Primeira lembranca: a floresta chama o guardiao.
        var _forest_a = clamp((timer - 24) / 34, 0, 1)
                      * clamp((190 - timer) / 42, 0, 1);
        if (sprite_exists(forest_sprite) && _forest_a > 0) {
            var _fsw = sprite_get_width(forest_sprite);
            var _fsh = sprite_get_height(forest_sprite);
            var _fzoom = max(_w / _fsw, _h / _fsh) * (1.05 + _t * 0.05);
            var _fdw = _fsw * _fzoom;
            var _fdh = _fsh * _fzoom;
            draw_set_alpha(_forest_a);
            draw_sprite_ext(forest_sprite, 0,
                (_w - _fdw) * 0.5 - 24 + _t * 48,
                (_h - _fdh) * 0.5 - 8 + sin(_t * pi) * 8,
                _fzoom, _fzoom, 0, c_white, _forest_a);
        }

        // Segunda lembranca: o lago aparece e ocupa toda a tela.
        var _lake_a = clamp((timer - 148) / 42, 0, 1);
        if (sprite_exists(lake_sprite) && _lake_a > 0) {
            var _lsw = sprite_get_width(lake_sprite);
            var _lsh = sprite_get_height(lake_sprite);
            var _lzoom = max(_w / _lsw, _h / _lsh) * (1.10 - _t * 0.035);
            var _ldw = _lsw * _lzoom;
            var _ldh = _lsh * _lzoom;
            draw_set_alpha(_lake_a);
            draw_sprite_ext(lake_sprite, 0,
                (_w - _ldw) * 0.5 + 22 - _t * 34,
                (_h - _ldh) * 0.5,
                _lzoom, _lzoom, 0, c_white, _lake_a);
        }

        // Faixas pixeladas conectam as artes ao estilo do jogo.
        draw_set_alpha(0.08 + sin(timer * 0.09) * 0.025);
        draw_set_colour(make_color_rgb(132, 255, 177));
        for (var _scan = 58; _scan < _h - 48; _scan += 8) {
            draw_rectangle(0, _scan, _w, _scan + 1, false);
        }

        // O protagonista atravessa as paisagens em forma de espirito.
        var _flight = clamp((timer - 62) / 172, 0, 1);
        var _flight_ease = _flight * _flight * (3 - 2 * _flight);
        var _hero_x = lerp(-120, _w + 145, _flight_ease);
        var _hero_y = _h * 0.53 + sin(_flight * pi * 4) * 72;
        var _hero_scale = 2.15 + sin(timer * 0.12) * 0.05;

        gpu_set_blendmode(bm_add);
        for (var _trail = 14; _trail >= 0; _trail--) {
            var _trail_x = _hero_x - _trail * 20;
            var _trail_y = _hero_y + sin((_flight - _trail * 0.008) * pi * 4) * 8;
            draw_set_alpha((1 - _trail / 15) * 0.16);
            draw_set_colour(merge_color(make_color_rgb(73, 255, 135), c_aqua, _trail / 15));
            draw_ellipse(_trail_x - 15, _trail_y - 5, _trail_x + 15, _trail_y + 5, false);
        }
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(clamp((timer - 48) / 24, 0, 1) * clamp((258 - timer) / 28, 0, 1));
        draw_sprite_ext(player_right_idle, 0, _hero_x, _hero_y,
            _hero_scale, _hero_scale, -8 + sin(timer * 0.07) * 4, c_white, 1);

        // Cartelas curtas e legiveis; o cenario continua sendo o destaque.
        var _caption = "";
        var _caption_a = 0;
        if (timer >= 55 && timer < 142) {
            _caption = "O TREINAMENTO TERMINOU.";
            _caption_a = clamp((timer - 55) / 18, 0, 1) * clamp((142 - timer) / 20, 0, 1);
        } else if (timer >= 174 && timer < 255) {
            _caption = "MAS O LAGO AINDA CLAMA.";
            _caption_a = clamp((timer - 174) / 18, 0, 1) * clamp((255 - timer) / 20, 0, 1);
        }
        if (_caption != "") {
            draw_set_font(fnt_menu);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_set_alpha(_caption_a * 0.78);
            draw_set_colour(c_black);
            draw_text_transformed(_cx + 3, _h - 72 + 3, _caption, 0.76, 0.76, 0);
            draw_set_alpha(_caption_a);
            draw_set_colour(make_color_rgb(239, 242, 211));
            draw_text_transformed(_cx, _h - 72, _caption, 0.76, 0.76, 0);
        }

        // Agua e luz fecham a tela exatamente quando a nova room e carregada.
        var _closing = clamp((timer - 252) / 48, 0, 1);
        for (var _wave = 0; _wave < 8; _wave++) {
            var _wave_y = lerp(_h + 80, -90, _closing) + _wave * 24;
            draw_set_alpha(_closing * (0.18 + _wave * 0.045));
            draw_set_colour(merge_color(make_color_rgb(31, 143, 181), make_color_rgb(75, 246, 136), _wave / 8));
            draw_rectangle(0, _wave_y, _w, _wave_y + 26, false);
        }
        draw_set_alpha(clamp((_closing - 0.70) / 0.30, 0, 1));
        draw_set_colour(make_color_rgb(2, 17, 18));
        draw_rectangle(0, 0, _w, _h, false);
    } else {
        // A Fase 1 ja esta por baixo: a cortina de agua se abre e libera o jogo.
        var _reveal = clamp((timer - duration_out) / duration_in, 0, 1);
        var _cover = 1 - _reveal * _reveal * (3 - 2 * _reveal);
        draw_set_alpha(_cover);
        draw_rectangle_color(0, 0, _w, _h,
            make_color_rgb(2, 17, 18), make_color_rgb(7, 47, 40),
            make_color_rgb(1, 10, 13), make_color_rgb(4, 31, 36), false);

        for (var _open_wave = 0; _open_wave < 9; _open_wave++) {
            var _open_y = _h * 0.5 + (_open_wave - 4) * 34;
            var _split = _reveal * (_w * 0.58 + _open_wave * 20);
            draw_set_alpha(_cover * (0.13 + _open_wave * 0.022));
            draw_set_colour(merge_color(make_color_rgb(37, 168, 185), make_color_rgb(86, 242, 132), _open_wave / 9));
            draw_rectangle(0, _open_y, max(0, _cx - _split), _open_y + 19, false);
            draw_rectangle(min(_w, _cx + _split), _open_y, _w, _open_y + 19, false);
        }

        draw_set_font(fnt_tutoras);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(_cover * clamp((0.82 - _reveal) / 0.30, 0, 1));
        draw_set_colour(c_black);
        draw_text_transformed(_cx + 4, _cy - 8 + 4, "FASE 1", 3.0, 3.0, 0);
        draw_set_colour(make_color_rgb(230, 230, 181));
        draw_text_transformed(_cx, _cy - 8, "FASE 1", 3.0, 3.0, 0);
        draw_set_font(fnt_dialogo);
        draw_set_colour(make_color_rgb(91, 236, 156));
        draw_text_transformed(_cx, _cy + 58, "O LAGO FERIDO", 1.15, 1.15, 0);
    }
} else {
    // Reserva simples caso o controlador seja reutilizado por outra passagem.
    var _progress;
    if (!room_switched) {
        _progress = clamp(timer / duration_out, 0, 1);
    } else {
        _progress = 1 - clamp((timer - duration_out) / duration_in, 0, 1);
    }
    var _smooth = _progress * _progress * (3 - 2 * _progress);
    draw_set_alpha(_smooth);
    draw_rectangle_color(0, 0, _w, _h,
        make_color_rgb(2, 14, 9), make_color_rgb(5, 35, 19),
        make_color_rgb(1, 8, 6), make_color_rgb(10, 43, 23), false);
}

// Barras cinematograficas e graos unem todos os momentos da passagem.
var _bars = room_switched
    ? 1 - clamp((timer - duration_out) / duration_in, 0, 1)
    : clamp(timer / 24, 0, 1);
draw_set_alpha(0.88 * _bars);
draw_set_colour(c_black);
draw_rectangle(0, 0, _w, 42, false);
draw_rectangle(0, _h - 42, _w, _h, false);

gpu_set_blendmode(bm_add);
for (var _dust = 0; _dust < 14; _dust++) {
    var _dust_x = (_dust * 113 + timer * (2 + (_dust mod 3))) mod (_w + 40) - 20;
    var _dust_y = (_dust * 67 + sin(timer * 0.025 + _dust) * 90 + _h) mod _h;
    draw_set_alpha(_bars * (0.06 + (_dust mod 3) * 0.018));
    draw_set_colour(make_color_rgb(126, 255, 169));
    draw_rectangle(_dust_x, _dust_y, _dust_x + 3, _dust_y + 3, false);
}
gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
gpu_set_texfilter(false);
