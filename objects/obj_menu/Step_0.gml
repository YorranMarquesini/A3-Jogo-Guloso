var _pad = scr_gamepad_slot();
var _pad_dir = pad_directions(_pad);

menu_time += delta_time / 1000000;
menu_selection_time += delta_time / 1000000;
if (instance_exists(oStudioIntro)) exit;

var _cima   = (_pad_dir.press_y < 0);
var _baixo  = (_pad_dir.press_y > 0);
var _entra  = controls_read(Bind.confirm, _pad) || controls_menu_space();
var _clique = mouse_check_button_pressed(mb_left);
var _selecao_anterior = opcao_selecionada;

if (_cima) opcao_selecionada = (opcao_selecionada - 1 + total_opcoes) mod total_opcoes;
if (_baixo) opcao_selecionada = (opcao_selecionada + 1) mod total_opcoes;

// O desenho e a area clicavel usam exatamente a mesma grade responsiva.
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _menu_x = _gui_w * 0.185;
var _menu_y = _gui_h * 0.605;
var _espaco = max(50, _gui_h * 0.072);
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _mouse_active = _clique || _mouse_x != menu_mouse_x || _mouse_y != menu_mouse_y;
menu_mouse_x = _mouse_x;
menu_mouse_y = _mouse_y;

for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = _menu_y + (i * _espaco);
    var _x1 = _menu_x - (largura_opcao / 2);
    var _x2 = _menu_x + (largura_opcao / 2);
    var _y1 = _pos_y - (altura_opcao / 2);
    var _y2 = _pos_y + (altura_opcao / 2);

    if (_mouse_active && _mouse_x >= _x1 && _mouse_x <= _x2 && _mouse_y >= _y1 && _mouse_y <= _y2) {
        opcao_selecionada = i;
        if (_clique) _entra = true;
    }
}

if (_selecao_anterior != opcao_selecionada) menu_selection_time = 0;

if (_entra) {
    switch (opcao_selecionada) {
        case 0: room_goto(sala_inicial); break;
        case 1: room_goto(rm_opcoes); break;
        case 2: room_goto(rm_creditos); break;
        case 3: game_end(); break;
    }
}
