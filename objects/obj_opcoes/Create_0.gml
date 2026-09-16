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
    "Voltar"
];

opcao_selecionada = 0;
total_opcoes = array_length(opcoes);

largura_opcao = 320;
altura_opcao = 40;