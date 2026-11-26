bindings_open = false;
// --- 1. DETECTAR RESOLUÇÕES SUPORTADAS ---
var _tela_w = display_get_width();
var _tela_h = display_get_height();

var _res_padrao = [
    [800, 600],
    [1024, 768],
    [1280, 720],
    [1366, 768],
    [1600, 900],
    [1920, 1080],
    [2560, 1440],
    [3840, 2160]
];

// A janela precisa caber na tela COM a barra de titulo e a barra de tarefas.
// Sem essa margem, escolher a resolucao do proprio monitor faz o Windows
// encolher a janela sozinho -- e o jogo abre menor do que voce pediu.
var _margem_w = 32;
var _margem_h = 96;

lista_resolucoes = [];
for (var i = 0; i < array_length(_res_padrao); i++) {
    if (_res_padrao[i][0] <= _tela_w - _margem_w
     && _res_padrao[i][1] <= _tela_h - _margem_h) {
        array_push(lista_resolucoes, _res_padrao[i]);
    }
}

// seguranca: a lista nunca pode ficar vazia
if (array_length(lista_resolucoes) == 0) {
    array_push(lista_resolucoes, [800, 600]);
}

// --- 2. VARIÁVEIS DE ESTADO ---
// Seleciona a maior resolução disponível no PC (último item da lista)
res_index = array_length(lista_resolucoes) - 1;

// Comeca na resolucao que a janela JA esta usando, se ela estiver na lista.
// Assim o menu mostra a verdade em vez de sempre apontar pra maior.
var _janela_w = window_get_width();
for (var i = 0; i < array_length(lista_resolucoes); i++) {
    if (lista_resolucoes[i][0] == _janela_w) {
        res_index = i;
        break;
    }
} 

// Lê o estado atual da tela cheia do jogo
fullscreen = window_get_fullscreen();

// Lê o volume global atual do jogo (0 a 100%)
volume_level = round(audio_get_master_gain(0) * 100); 
arrastando_volume = false;

// --- 3. ESTRUTURA DO MENU ---
opcoes = [
    "Resolucao", 
    fullscreen ? "Tela Cheia: LIGADO" : "Tela Cheia: DESLIGADO", 
    "Volume", 
    "Controles",
    "Voltar"
];

opcao_selecionada = 0;
total_opcoes = array_length(opcoes);

largura_opcao = 320;
altura_opcao = 40;

// Identidade visual compartilhada com a tela inicial.
ui_time = 0;
var _variant = variable_global_exists("menu_variant") ? global.menu_variant : 0;
var _names = ["menu_dawn.png", "menu_temple.png", "menu_wasteland.png"];
var _colors = [make_color_rgb(147, 190, 88), make_color_rgb(87, 181, 132), make_color_rgb(190, 145, 61)];
ui_accent = _colors[_variant];
ui_background = sprite_add(working_directory + "menu/" + _names[_variant], 1, false, false, 0, 0);
largura_opcao = 620;
altura_opcao = 58;

menu_mouse_x = -1;
menu_mouse_y = -1;
