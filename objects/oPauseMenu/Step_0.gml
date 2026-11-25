// A reativacao so e concluida ao fim do evento que a solicitou.
if (pause_exit != 0) {
    if (keyboard_check(vk_enter) || keyboard_check(vk_space) || keyboard_check(vk_escape)) exit;
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

var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _back = keyboard_check_pressed(vk_escape);

if (mouse_check_button_pressed(mb_left)) {
    var _gui_h = display_get_gui_height();
    var _cx = display_get_gui_width() * 0.5;
    var _panel_top = (_gui_h - min(520, _gui_h * 0.76)) * 0.5;
    var _mouse_y = device_mouse_y_to_gui(0);
    var _spacing = pagina == 0 ? 86 : 70;
    var _choice = round((_mouse_y - _panel_top - 158) / _spacing);
    if (abs(device_mouse_x_to_gui(0) - _cx) <= 250
    && _choice >= 0 && _choice < (pagina == 0 ? 3 : 4)
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
    if (_up) opcao = (opcao + 3) mod 4;
    if (_down) opcao = (opcao + 1) mod 4;

    if (opcao == 0) {
        var _res_change = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))
                        ? 1
                        : (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")) ? -1 : 0);
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

    if (_back || (_confirm && opcao == 3)) {
        pagina = 0;
        opcao = 1;
    }
}
