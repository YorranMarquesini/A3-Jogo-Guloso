var _pad = scr_gamepad_slot();
var _pad_dir = pad_directions(_pad);
if (bindings_open) { controls_editor_step(_pad, _pad_dir); exit; }

ui_time += delta_time / 1000000;

// --- 1. ENTRADAS DE TECLADO E MOUSE ---
var _cima           = (_pad_dir.press_y < 0);
var _baixo          = (_pad_dir.press_y > 0);

var _esquerda_hold  = (_pad_dir.dx < 0);
var _direita_hold   = (_pad_dir.dx > 0);

var _esquerda_press = (_pad_dir.press_x < 0);
var _direita_press  = (_pad_dir.press_x > 0);

var _entra          = controls_read(Bind.confirm, _pad) || controls_menu_space();
var _clique_press   = mouse_check_button_pressed(mb_left);
var _clique_hold    = mouse_check_button(mb_left);
var _clique_soltou  = mouse_check_button_released(mb_left);
var _voltar         = controls_read(Bind.back, _pad);

if (_voltar) {
    room_goto(rm_menu);
}

// --- 2. NAVEGAÇÃO VERTICAL (TECLADO) ---
if (_cima) {
    opcao_selecionada--;
    if (opcao_selecionada < 0) opcao_selecionada = total_opcoes - 1;
}

if (_baixo) {
    opcao_selecionada++;
    if (opcao_selecionada >= total_opcoes) opcao_selecionada = 0;
}

// --- 3. INTERAÇÃO E SELEÇÃO POR MOUSE ---
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _mouse_active = _clique_press || _mouse_x != menu_mouse_x || _mouse_y != menu_mouse_y;
menu_mouse_x = _mouse_x;
menu_mouse_y = _mouse_y;

// Posições da barra de volume (devem bater com o Draw GUI)
var _base_y = _gui_h * 0.40;
var _espaco = _gui_h * 0.105;
var _barra_w = 260;
var _barra_h = 34; // Altura da área clicável
var _x_barra = (_gui_w / 2) - 70;
var _pos_y_vol = _base_y + (2 * _espaco); // Posição Y da opção 2 (Volume)

// Verifica se o clique inicial começou dentro da barra de volume
if (_clique_press) {
    if (_mouse_x >= _x_barra && _mouse_x <= _x_barra + _barra_w &&
        _mouse_y >= _pos_y_vol - (_barra_h / 2) && _mouse_y <= _pos_y_vol + (_barra_h / 2)) {
        arrastando_volume = true;
        opcao_selecionada = 2;
    }
}

// Soltar o botão do mouse encerra o arrasto
if (_clique_soltou) {
    arrastando_volume = false;
}

// Se estiver clicando e arrastando a barra de volume
if (arrastando_volume && _clique_hold) {
    var _porcentagem = (_mouse_x - _x_barra) / _barra_w;
    volume_level = clamp(round(_porcentagem * 100), 0, 100);
    audio_master_gain(volume_level / 100);
}

// Destaque visual pelo mouse nas outras opções (quando não estiver arrastando a barra)
if (!arrastando_volume) {
    for (var i = 0; i < total_opcoes; i++) {
        var _pos_y = _base_y + (i * _espaco);
        var _x1 = (_gui_w / 2) - (largura_opcao / 2);
        var _x2 = (_gui_w / 2) + (largura_opcao / 2);
        var _y1 = _pos_y - (altura_opcao / 2);
        var _y2 = _pos_y + (altura_opcao / 2);

        if (_mouse_active && _mouse_x >= _x1 && _mouse_x <= _x2 && _mouse_y >= _y1 && _mouse_y <= _y2) {
            opcao_selecionada = i;
            if (_clique_press && i != 2) _entra = true; // Clique confirma apenas para botões normais
        }
    }
}

// --- 4. FUNÇÃO AUXILIAR PARA RESOLUÇÃO ---
var _mudar_resolucao = function(_direcao) {
    var _total_res = array_length(lista_resolucoes);
    res_index += _direcao;
    
    if (res_index < 0) res_index = _total_res - 1;
    if (res_index >= _total_res) res_index = 0;
    
    var _nova_res = lista_resolucoes[res_index];
    var _w = _nova_res[0];
    var _h = _nova_res[1];
    
    // Aqui muda SO o tamanho da janela.
    // A resolucao interna do jogo continua BASE_WIDTH x BASE_HEIGHT --
    // e por isso que a quantidade de cenario visivel nunca muda.
    if (window_get_fullscreen()) {
        window_set_fullscreen(false);
        fullscreen = false;
        opcoes[1]  = "Tela Cheia: DESLIGADO";
    }

    // Nao chamamos window_set_size direto aqui: sair da tela cheia leva
    // alguns frames, e no caminho o Windows restaura o tamanho ANTIGO da
    // janela, passando por cima do que acabamos de pedir.
    // window_request_size anota o pedido e insiste ate a janela obedecer.
    window_request_size(_w, _h);
};

// --- 5. AÇÕES PARA TECLADO (SETAS ESQUERDA/DIREITA) ---
if (opcao_selecionada == 0) { // Resolução
    if (_esquerda_press) _mudar_resolucao(-1);
    if (_direita_press)  _mudar_resolucao(1);
}

if (opcao_selecionada == 2) { // Volume via teclado
    if (_esquerda_hold) {
        volume_level = clamp(volume_level - 1, 0, 100);
        audio_master_gain(volume_level / 100);
    }
    if (_direita_hold) {
        volume_level = clamp(volume_level + 1, 0, 100);
        audio_master_gain(volume_level / 100);
    }
}

// --- 6. AÇÕES DE CONFIRMAÇÃO (ENTER OU CLIQUE EM BOTÕES) ---
if (_entra) {
    switch (opcao_selecionada) {
        case 0: // Clique/Enter na Resolução
            _mudar_resolucao(1);
            break;
            
        case 1: // Alternar Tela Cheia
            fullscreen = !fullscreen;
            window_set_fullscreen(fullscreen);
            opcoes[1] = fullscreen ? "Tela Cheia: LIGADO" : "Tela Cheia: DESLIGADO";

            if (!fullscreen) {
                // voltando pra janela: devolve a resolucao escolhida na lista
                var _r = lista_resolucoes[res_index];
                window_request_size(_r[0], _r[1]);
            }
            break;
            
        case 3:
            controls_editor_open();
            break;
        case 4: // Voltar
            room_goto(rm_menu);
            break;
    }
}
