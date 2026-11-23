var _w = display_get_gui_width();
var _h = display_get_gui_height();
var _elapsed = (current_time - start_ms) / 1000;

draw_clear(c_black);
gpu_set_texfilter(false);
draw_set_alpha(1);
draw_set_color(c_white);

// Cinco lembrancas da destruicao, com cortes suaves e um zoom bem lento.
if (_elapsed < 15 && scenes_ready) {
    var _scene = clamp(floor(_elapsed / 3), 0, 4);
    var _local = _elapsed - (_scene * 3);
    var _zoom = 1.02 + (_local / 3) * 0.035;
    var _dw = _w * _zoom;
    var _dh = _h * _zoom;
    var _dx = (_w - _dw) * 0.5;
    var _dy = (_h - _dh) * 0.5;

    draw_sprite_stretched_ext(scene_sprites[_scene], 0, _dx, _dy, _dw, _dh, c_white, 1);

    if (_local > 2.35 && _scene < 4) {
        var _fade = (_local - 2.35) / 0.65;
        draw_sprite_stretched_ext(scene_sprites[_scene + 1], 0, 0, 0, _w, _h, c_white, _fade);
    }

    // Pequeno fade preto em cada ponta deixa a sequencia cinematografica.
    var _edge_fade = 0;
    if (_elapsed < 0.8) _edge_fade = 1 - (_elapsed / 0.8);
    if (_elapsed > 14.2) _edge_fade = max(_edge_fade, (_elapsed - 14.2) / 0.8);
    draw_set_alpha(clamp(_edge_fade, 0, 1));
    draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
}

// Se um arquivo externo falhar, mostra uma introducao simples em vez de tela preta muda.
if (_elapsed < 15 && !scenes_ready) {
    var _fallback_fade = 0.22 + sin(_elapsed * 1.7) * 0.06;
    draw_rectangle_color(0, 0, _w, _h,
        make_color_rgb(3, 18, 10),
        make_color_rgb(8, 40, 20),
        make_color_rgb(1, 8, 5),
        make_color_rgb(3, 22, 12), false);
    gpu_set_blendmode(bm_add);
    draw_set_alpha(_fallback_fade);
    draw_set_color(make_color_rgb(40, 255, 100));
    for (var f = 0; f < 12; f++) {
        var _fx = ((_elapsed * 46) + f * 127) mod (_w + 120) - 60;
        var _fy = _h * 0.35 + sin(_elapsed * 1.4 + f) * 180;
        draw_circle(_fx, _fy, 5 + (f mod 4) * 2, false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Nave pousando e destruindo a floresta. O arquivo ja esta recortado, mudo e pixelado.
if (_elapsed >= 15 && _elapsed < 44.5 && video_started) {
    var _video = video_draw();
    if (array_length(_video) > 1 && _video[0] == 0 && surface_exists(_video[1])) {
        draw_surface_stretched(_video[1], 0, 0, _w, _h);
    }

    var _video_fade = 0;
    if (_elapsed < 15.7) _video_fade = 1 - ((_elapsed - 15) / 0.7);
    if (_elapsed > 43.7) _video_fade = max(_video_fade, (_elapsed - 43.7) / 0.8);
    draw_set_alpha(clamp(_video_fade, 0, 1));
    draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
}

// O espirito atravessa o vazio e desperta o personagem.
if (_elapsed >= 47 && _elapsed < 55) {
    var _spirit_time = clamp((_elapsed - 47) / 5.2, 0, 1);
    var _ease = _spirit_time * _spirit_time * (3 - 2 * _spirit_time);
    var _player_x = _w * 0.68;
    var _player_y = _h * 0.55;
    var _player_alpha = clamp((_elapsed - 47.2) / 1.1, 0, 1);
    var _pulse = 1 + sin(_elapsed * 7) * 0.025;

    draw_sprite_ext(player_right_idle, 0, _player_x, _player_y, 4 * _pulse, 4 * _pulse, 0, c_white, _player_alpha);

    var _sx = lerp(-100, _player_x - 16, _ease);
    var _sy = lerp(_h * 0.34, _player_y - 22, _ease) + sin(_spirit_time * pi * 5) * 72 * (1 - _spirit_time);
    var _shrink = 1 - clamp((_spirit_time - 0.86) / 0.14, 0, 1);

    gpu_set_blendmode(bm_add);
    for (var i = 14; i >= 0; i--) {
        var _trail_p = max(0, _spirit_time - i * 0.012);
        var _trail_ease = _trail_p * _trail_p * (3 - 2 * _trail_p);
        var _tx = lerp(-100, _player_x - 16, _trail_ease);
        var _ty = lerp(_h * 0.34, _player_y - 22, _trail_ease) + sin(_trail_p * pi * 5) * 72 * (1 - _trail_p);
        var _trail_alpha = (1 - i / 15) * 0.22 * _shrink;
        draw_set_alpha(_trail_alpha);
        draw_set_color(make_color_rgb(70, 255, 125));
        draw_circle(_tx, _ty, 7 + (14 - i) * 0.55, false);
    }

    draw_set_alpha(0.18 * _shrink);
    draw_set_color(make_color_rgb(30, 255, 100));
    draw_circle(_sx, _sy, 42 * _shrink, false);
    draw_set_alpha(0.75 * _shrink);
    draw_set_color(make_color_rgb(155, 255, 185));
    draw_circle(_sx, _sy, 15 * _shrink, false);
    draw_set_alpha(1 * _shrink);
    draw_set_color(c_white);
    draw_circle(_sx + 3, _sy - 3, 5 * _shrink, false);

    if (_spirit_time > 0.86) {
        var _flash = sin(((_spirit_time - 0.86) / 0.14) * pi);
        draw_set_alpha(_flash * 0.45);
        draw_set_color(make_color_rgb(80, 255, 130));
        draw_circle(_player_x, _player_y - 18, 95 * _flash, false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_color(c_white);

    if (_elapsed > 53.8) {
        draw_set_alpha(clamp((_elapsed - 53.8) / 1.2, 0, 1));
        draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
    }
}

// Aviso discreto, usando a mesma fonte do menu.
if (_elapsed > 1 && _elapsed < 53.5) {
    draw_set_font(fnt_menu);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(0.55 + sin(_elapsed * 3) * 0.15);
    draw_text(_w - 28, _h - 20, "ESPACO PARA PULAR");
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
gpu_set_texfilter(false);
