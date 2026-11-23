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
    var _zoom = 1.015 + (_local / 3) * 0.025;
    var _dw = _w * _zoom;
    var _dh = _h * _zoom;
    var _pan_dir = ((_scene mod 2) * 2) - 1;
    var _pan = ((_local / 3) - 0.5) * 24 * _pan_dir;
    var _scene_shake = ((_scene == 1) || (_scene == 2)) ? 2.2 : 0.65;
    var _dx = (_w - _dw) * 0.5 + _pan + sin(_elapsed * 17) * _scene_shake;
    var _dy = (_h - _dh) * 0.5 + sin((_local / 3) * pi) * 5 + cos(_elapsed * 13) * _scene_shake * 0.55;

    draw_sprite_stretched_ext(scene_sprites[_scene], 0, _dx, _dy, _dw, _dh, c_white, 1);

    if (_local > 2.1 && _scene < 4) {
        var _fade_linear = (_local - 2.1) / 0.9;
        var _fade = _fade_linear * _fade_linear * (3 - 2 * _fade_linear);
        draw_sprite_stretched_ext(scene_sprites[_scene + 1], 0, 0, 0, _w, _h, c_white, _fade);

        // Separacao de cores e vazamento de luz durante a troca de imagem.
        var _burn = sin(_fade * pi);
        gpu_set_blendmode(bm_add);
        draw_sprite_stretched_ext(scene_sprites[_scene + 1], 0, -3, 0, _w, _h, make_color_rgb(255, 80, 35), _burn * 0.07);
        draw_sprite_stretched_ext(scene_sprites[_scene + 1], 0, 3, 0, _w, _h, make_color_rgb(30, 150, 255), _burn * 0.045);
        draw_set_alpha(_burn * 0.15);
        draw_rectangle_color(0, 0, _w, _h,
            make_color_rgb(255, 65, 8),
            make_color_rgb(255, 195, 65),
            make_color_rgb(20, 5, 0),
            make_color_rgb(65, 8, 0), false);
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
    }

    // Flash curto no corte, como uma emenda de pelicula aquecida.
    if (_local < 0.18 && _scene > 0) {
        draw_set_alpha((1 - _local / 0.18) * 0.22);
        draw_rectangle_color(0, 0, _w, _h, c_white, make_color_rgb(255, 180, 90), c_black, c_black, false);
        draw_set_alpha(1);
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

// O espirito atravessa o vazio, entra pelo olho e desperta o personagem.
if (_elapsed >= 47 && _elapsed < 56.5) {
    var _spirit_time = clamp((_elapsed - 47) / 5.2, 0, 1);
    var _ease = _spirit_time * _spirit_time * (3 - 2 * _spirit_time);
    var _player_x = _w * 0.68;
    var _player_y = _h * 0.55;
    var _player_alpha = clamp((_elapsed - 47.2) / 1.1, 0, 1);
    var _pulse = 1 + sin(_elapsed * 7) * 0.025;
    var _player_scale = 4 * _pulse;
    var _awakened = _spirit_time >= 0.88;
    var _impact_amount = clamp((_spirit_time - 0.88) / 0.12, 0, 1);
    var _shake = 0;
    if (_awakened) _shake = sin(_elapsed * 75) * 7 * (1 - _impact_amount);
    _player_x += _shake;

    // Posicao do pixel verde dentro do sprite 64x64 (origem 24,60).
    var _eye_x = _player_x + (46.5 - 24) * _player_scale;
    var _eye_y = _player_y + (23.5 - 60) * _player_scale;

    draw_sprite_ext(player_right_idle, 0, _player_x, _player_y, _player_scale, _player_scale, 0, c_white, _player_alpha);

    // Antes do espirito chegar, o olho fica completamente apagado.
    if (!_awakened) {
        draw_set_alpha(_player_alpha);
        draw_set_color(make_color_rgb(10, 11, 14));
        draw_rectangle(
            _player_x + (45 - 24) * _player_scale,
            _player_y + (22 - 60) * _player_scale,
            _player_x + (48 - 24) * _player_scale,
            _player_y + (25 - 60) * _player_scale,
            false
        );
        draw_set_alpha(1);
        draw_set_color(c_white);
    }

    var _sx = lerp(-120, _eye_x, _ease);
    var _sy = lerp(_h * 0.34, _eye_y, _ease) + sin(_spirit_time * pi * 5) * 72 * (1 - _spirit_time);
    var _shrink = 1 - clamp((_spirit_time - 0.86) / 0.14, 0, 1);

    gpu_set_blendmode(bm_add);
    for (var i = 20; i >= 0; i--) {
        var _trail_p = max(0, _spirit_time - i * 0.009);
        var _trail_ease = _trail_p * _trail_p * (3 - 2 * _trail_p);
        var _tx = lerp(-120, _eye_x, _trail_ease);
        var _ty = lerp(_h * 0.34, _eye_y, _trail_ease) + sin(_trail_p * pi * 5) * 72 * (1 - _trail_p);
        var _trail_alpha = (1 - i / 21) * 0.18 * _shrink;
        draw_set_alpha(_trail_alpha);
        draw_set_color(make_color_rgb(70, 255, 125));
        draw_circle(_tx, _ty, 5 + (20 - i) * 0.42, false);
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

    if (_awakened) {
        var _flash = sin(_impact_amount * pi);
        draw_set_alpha(_flash * 0.58);
        draw_set_color(make_color_rgb(80, 255, 130));
        draw_circle(_eye_x, _eye_y, 135 * _flash, false);

        // Ondas e estilhacos de energia no momento do despertar.
        for (var r = 0; r < 3; r++) {
            var _ring_p = clamp(_impact_amount * 1.35 - r * 0.18, 0, 1);
            draw_set_alpha((1 - _ring_p) * 0.42);
            draw_circle(_eye_x, _eye_y, 24 + _ring_p * (115 + r * 28), true);
        }
        for (var p = 0; p < 18; p++) {
            var _angle = p * (360 / 18) + 12;
            var _dist = 18 + _impact_amount * (75 + (p mod 4) * 18);
            var _px = _eye_x + lengthdir_x(_dist, _angle);
            var _py = _eye_y + lengthdir_y(_dist, _angle);
            draw_set_alpha((1 - _impact_amount) * 0.75);
            draw_circle(_px, _py, 2 + (p mod 3), false);
        }

        // O olho so acende depois que o espirito entra.
        draw_set_alpha(0.35 + sin(_elapsed * 12) * 0.12);
        draw_circle(_eye_x, _eye_y, 28, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(120, 255, 105));
        draw_rectangle(_eye_x - 6, _eye_y - 6, _eye_x + 6, _eye_y + 6, false);
        draw_set_color(c_white);
        draw_rectangle(_eye_x - 2, _eye_y - 2, _eye_x + 2, _eye_y + 2, false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_color(c_white);

    if (_elapsed > 55.2) {
        draw_set_alpha(clamp((_elapsed - 55.2) / 1.3, 0, 1));
        draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
    }
}

// Vinheta, poeira de filme e barras panoramicas unem as cenas visualmente.
draw_set_alpha(0.38);
draw_rectangle_color(0, 0, 80, _h, c_black, c_black, c_black, c_black, false);
draw_rectangle_color(_w - 80, 0, _w, _h, c_black, c_black, c_black, c_black, false);
draw_set_alpha(0.18);
draw_rectangle_color(80, 0, 150, _h, c_black, c_black, c_black, c_black, false);
draw_rectangle_color(_w - 150, 0, _w - 80, _h, c_black, c_black, c_black, c_black, false);

gpu_set_blendmode(bm_add);
for (var d = 0; d < 9; d++) {
    var _dust_x = (d * 173 + floor(_elapsed * (19 + d))) mod _w;
    var _dust_y = (d * 97 + sin(_elapsed * 0.7 + d) * 85 + _h) mod _h;
    draw_set_alpha(0.05 + (d mod 3) * 0.018);
    draw_set_color(make_color_rgb(210, 230, 200));
    draw_circle(_dust_x, _dust_y, 1 + (d mod 2), false);
}
gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, _w, 48, false);
draw_rectangle(0, _h - 48, _w, _h, false);

// Frases curtas, como cartelas de uma abertura de cinema.
var _caption = "";
var _caption_alpha = 0;
if (_elapsed >= 1 && _elapsed < 5.4) {
    _caption = "ELES CHAMARAM ISSO DE PROGRESSO.";
    _caption_alpha = min(1, (_elapsed - 1) / 0.8) * min(1, (5.4 - _elapsed) / 0.8);
}
else if (_elapsed >= 9.3 && _elapsed < 14.2) {
    _caption = "ATE QUE A TERRA COMECOU A MORRER.";
    _caption_alpha = min(1, (_elapsed - 9.3) / 0.8) * min(1, (14.2 - _elapsed) / 0.8);
}
else if (_elapsed >= 44.3 && _elapsed < 47.7) {
    _caption = "MAS A NATUREZA NAO ESQUECE.";
    _caption_alpha = min(1, (_elapsed - 44.3) / 0.6) * min(1, (47.7 - _elapsed) / 0.6);
}
else if (_elapsed >= 51.6 && _elapsed < 55.9) {
    _caption = "E ELA ESCOLHEU VOCE O ULTIMO GUARDIÃO.";
    _caption_alpha = min(1, (_elapsed - 51.6) / 0.6) * min(1, (55.9 - _elapsed) / 0.6);
}

if (_caption != "") {
    draw_set_font(fnt_menu);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_black);
    draw_set_alpha(_caption_alpha * 0.75);
    draw_text_transformed(_w * 0.5 + 2, _h - 68 + 2, _caption, 0.72, 0.72, 0);
    draw_set_color(c_white);
    draw_set_alpha(_caption_alpha);
    draw_text_transformed(_w * 0.5, _h - 68, _caption, 0.72, 0.72, 0);
}

// Aviso discreto, usando a mesma fonte do menu.
if (_elapsed > 1 && _elapsed < 55.2) {
    draw_set_font(fnt_menu);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(0.42 + sin(_elapsed * 3) * 0.10);
    draw_text_transformed(_w - 24, _h - 13, "ESPACO PARA PULAR", 0.58, 0.58, 0);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
gpu_set_texfilter(false);
