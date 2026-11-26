var _pad = scr_gamepad_slot();
var _pad_dir = pad_directions(_pad);
if (bindings_open) { controls_editor_step(_pad, _pad_dir); exit; }

// A reativacao so e concluida ao fim do evento que a solicitou.
if (pause_exit != 0) {
    if (controls_read(Bind.pause, _pad, BindState.held) || controls_read(Bind.confirm, _pad, BindState.held) || controls_read(Bind.back, _pad, BindState.held)) exit;
    if (pause_exit == 2) scr_voltar_ao_menu();
    instance_destroy();
    exit;
}

window_apply_pending();
fade = min(1, fade + 0.1);
ui_time += 0.055;

if (atraso > 0) {
    atraso--;
    exit;
}

var _up = (_pad_dir.press_y < 0);
var _down = (_pad_dir.press_y > 0);
var _left = (_pad_dir.dx < 0);
var _right = (_pad_dir.dx > 0);
var _confirm = controls_read(Bind.confirm, _pad) || controls_menu_space();
var _back = controls_read(Bind.back, _pad) || (_pad >= 0 && gamepad_button_check_pressed(_pad, global.controls_pad[Bind.pause]) && global.controls_pad[Bind.pause] != global.controls_pad[Bind.confirm]);

if (mouse_check_button_pressed(mb_left)) {
    var _gui_h = display_get_gui_height();
    var _cx = display_get_gui_width() * 0.5;
    var _panel_top = (_gui_h - min(520, _gui_h * 0.76)) * 0.5;
    var _mouse_y = device_mouse_y_to_gui(0);
    var _spacing = pagina == 0 ? 86 : 62;
    var _choice = round((_mouse_y - _panel_top - 158) / _spacing);
    if (abs(device_mouse_x_to_gui(0) - _cx) <= 250
    && _choice >= 0 && _choice < (pagina == 0 ? 3 : 5)
    && abs(_mouse_y - (_panel_top + 158 + _choice * _spacing)) <= 30) {
        opcao = _choice;
        _confirm = true;
    }
}

if (pagina == 0) {
    if (_up) opcao = (opcao + 2) mod 3;
    if (_down) opcao = (opcao + 1) mod 3;

    if (_back || (_confirm && opcao == 0)) pause_close(1);
    else if (_confirm && opcao == 1) {
        pagina = 1;
        opcao = 0;
    } else if (_confirm && opcao == 2) {
        pause_close(2);
    }
} else {
    if (_up) opcao = (opcao + 4) mod 5;
    if (_down) opcao = (opcao + 1) mod 5;

    if (opcao == 0) {
        var _res_change = (_pad_dir.press_x > 0)
                        ? 1
                        : ((_pad_dir.press_x < 0) ? -1 : 0);
        if (_res_change != 0) {
            res_index = (res_index + _res_change + array_length(lista_resolucoes)) mod array_length(lista_resolucoes);
            var _res = lista_resolucoes[res_index];
            if (window_get_fullscreen()) {
                window_set_fullscreen(false);
                fullscreen = false;
            }
            window_request_size(_res[0], _res[1]);
        }
    }

    if (opcao == 2) {
        if (_left) volume_level = clamp(volume_level - 1, 0, 100);
        if (_right) volume_level = clamp(volume_level + 1, 0, 100);
        audio_master_gain(volume_level / 100);
    }

    if (_confirm && opcao == 1) {
        fullscreen = !fullscreen;
        window_set_fullscreen(fullscreen);
    }

    if (_confirm && opcao == 3) controls_editor_open();
    if (_back || (_confirm && opcao == 4)) {
        pagina = 0;
        opcao = 1;
    }
}
