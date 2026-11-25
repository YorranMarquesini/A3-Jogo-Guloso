if (room == BossRoom && sprite_exists(boss_backdrop)) {
    var _purify = 0;
    var _boss_instance = instance_find(oBoss, 0);
    if (instance_exists(_boss_instance) && _boss_instance.final_explosion_started) {
        _purify = clamp((80 - _boss_instance.final_explosion_timer) / 80, 0, 1);
    }

    var _polluted_tint = make_color_rgb(112, 137, 112);
    draw_sprite_stretched_ext(boss_backdrop, 0, 0, 0, room_width, room_height,
        merge_color(_polluted_tint, c_white, _purify), 1);

    // Fumaca industrial e nevoa suja somem conforme o guardiao e derrotado.
    draw_set_alpha(0.36 * (1 - _purify));
    draw_rectangle_colour(0, 0, room_width, room_height,
        make_color_rgb(63, 74, 62), make_color_rgb(75, 73, 58),
        make_color_rgb(34, 56, 49), make_color_rgb(34, 56, 49), false);
    draw_set_alpha(0.18 * (1 - _purify));
    for (var _smog = 0; _smog < 7; _smog++) {
        var _smog_y = 250 + _smog * 92 + sin(current_time * 0.0008 + _smog) * 18;
        draw_set_colour((_smog mod 2 == 0) ? make_color_rgb(99, 91, 66) : make_color_rgb(72, 86, 69));
        draw_rectangle(-80 + (_smog mod 3) * 170, _smog_y, room_width + 60, _smog_y + 38, false);
    }

    // Agua frontal animada abaixo das plataformas. Os blocos largos e os
    // poucos tons mantem a leitura de pixel art mesmo com a camera ampliada.
    var _water_top = 1040;
    draw_set_alpha(0.84);
    draw_rectangle_colour(0, _water_top, room_width, room_height,
        merge_color(make_color_rgb(50, 105, 82), make_color_rgb(35, 132, 181), _purify),
        merge_color(make_color_rgb(50, 105, 82), make_color_rgb(35, 132, 181), _purify),
        merge_color(make_color_rgb(22, 58, 47), make_color_rgb(8, 55, 105), _purify),
        merge_color(make_color_rgb(22, 58, 47), make_color_rgb(8, 55, 105), _purify), false);

    var _dirty_wave_colors = [
        make_color_rgb(121, 145, 91),
        make_color_rgb(74, 119, 79),
        make_color_rgb(44, 89, 67),
        make_color_rgb(29, 66, 57)
    ];
    var _clean_wave_colors = [
        make_color_rgb(145, 224, 225), make_color_rgb(79, 181, 205),
        make_color_rgb(31, 112, 170), make_color_rgb(15, 77, 139)
    ];

    for (var _row = 0; _row < 12; _row++) {
        var _base_y = _water_top + 8 + _row * 20;
        var _wave_index = _row mod array_length(_dirty_wave_colors);
        var _wave_color = merge_color(_dirty_wave_colors[_wave_index], _clean_wave_colors[_wave_index], _purify);
        draw_set_colour(_wave_color);

        for (var _wx = -64; _wx < room_width + 64; _wx += 96) {
            var _offset = round(sin(current_time * 0.003 + _row * 0.8 + _wx * 0.012) * 6);
            var _shift = ((_row mod 2) * 38) + _offset;
            var _segment_w = 42 + ((_row * 13 + _wx) mod 30);
            draw_rectangle(_wx + _shift, _base_y, _wx + _shift + _segment_w, _base_y + 4, false);
        }
    }

    // Manchas de oleo e lixo boiando. Tudo dissolve durante a purificacao.
    draw_set_alpha(0.74 * (1 - _purify));
    for (var _oil = 0; _oil < 11; _oil++) {
        var _oil_x = 70 + _oil * 225 + sin(current_time * 0.0015 + _oil) * 22;
        var _oil_y = _water_top + 22 + (_oil mod 4) * 41;
        draw_set_colour((_oil mod 2 == 0) ? make_color_rgb(36, 31, 38) : make_color_rgb(53, 45, 31));
        draw_rectangle(_oil_x, _oil_y, _oil_x + 90 + (_oil mod 3) * 18, _oil_y + 9, false);
        draw_rectangle(_oil_x + 28, _oil_y - 5, _oil_x + 64, _oil_y + 13, false);
    }

    for (var _trash = 0; _trash < 9; _trash++) {
        var _trash_x = 150 + _trash * 270 + sin(current_time * 0.002 + _trash * 1.7) * 16;
        var _trash_y = _water_top + 15 + (_trash mod 3) * 58;
        if (_trash mod 2 == 0) {
            // Garrafa de plastico pixelada.
            draw_set_colour(make_color_rgb(126, 151, 128));
            draw_rectangle(_trash_x, _trash_y, _trash_x + 34, _trash_y + 11, false);
            draw_set_colour(make_color_rgb(78, 105, 83));
            draw_rectangle(_trash_x + 34, _trash_y + 3, _trash_x + 42, _trash_y + 8, false);
        } else {
            // Sacola amassada.
            draw_set_colour(make_color_rgb(129, 119, 91));
            draw_rectangle(_trash_x, _trash_y, _trash_x + 28, _trash_y + 19, false);
            draw_rectangle(_trash_x + 5, _trash_y - 6, _trash_x + 10, _trash_y + 2, false);
            draw_rectangle(_trash_x + 19, _trash_y - 6, _trash_x + 24, _trash_y + 2, false);
        }
    }

    // Espuma clara marca onde o monstro rompeu a superficie.
    draw_set_alpha(0.62 + sin(current_time * 0.008) * 0.10);
    draw_set_colour(merge_color(make_color_rgb(150, 164, 108), make_color_rgb(196, 239, 235), _purify));
    for (var _foam = 0; _foam < 9; _foam++) {
        var _fx = 1480 + _foam * 54 + sin(current_time * 0.005 + _foam) * 18;
        draw_rectangle(_fx, _water_top + 4 + (_foam mod 3) * 4, _fx + 35, _water_top + 8 + (_foam mod 3) * 4, false);
    }

    draw_set_alpha(1);
    draw_set_colour(c_white);
}
