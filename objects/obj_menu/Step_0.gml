var _cima   = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var _baixo  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var _entra  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _clique = mouse_check_button_pressed(mb_left);

// --- NAVEGAÇÃO POR TECLADO ---
if (_cima) {
    opcao_selecionada--;
    if (opcao_selecionada < 0) opcao_selecionada = total_opcoes - 1;
}

if (_baixo) {
    opcao_selecionada++;
    if (opcao_selecionada >= total_opcoes) opcao_selecionada = 0;
}

// --- NAVEGAÇÃO POR MOUSE ---
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

for (var i = 0; i < total_opcoes; i++) {
    var _pos_y = (_gui_h / 2) - 60 + (i * 50);
    var _x1 = (_gui_w / 2) - (largura_opcao / 2);
    var _x2 = (_gui_w / 2) + (largura_opcao / 2);
    var _y1 = _pos_y - (altura_opcao / 2);
    var _y2 = _pos_y + (altura_opcao / 2);

    // Se o ponteiro do mouse estiver sobre a opção
    if (_mouse_x >= _x1 && _mouse_x <= _x2 && _mouse_y >= _y1 && _mouse_y <= _y2) {
        opcao_selecionada = i;
        if (_clique) _entra = true; // Confirma a seleção com clique do mouse
    }
}

// --- EXECUÇÃO DAS AÇÕES ---
if (_entra) {
    switch (opcao_selecionada) {
        case 0: // Start -> Vai para a Sala do Jogo
			room_goto(sala_inicial);
            break;
            
        case 1: // Opções -> Vai para a Sala de Opções
            room_goto(rm_opcoes);
            break;
            
        case 2: // Créditos -> Vai para a Sala de Créditos
            room_goto(rm_creditos);
            break;
            
        case 3: // Exit -> Fecha o jogo
            game_end();
            break;
    }
}