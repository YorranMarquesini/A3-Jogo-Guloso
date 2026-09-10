// 1. Evita instâncias duplicadas ao trocar de sala
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

// 2. DETECÇÃO AUTOMÁTICA DA TELA
// Pega a largura e altura MÁXIMA reais do monitor em que o jogo foi aberto
var _largura_monitor = display_get_width();
var _altura_monitor  = display_get_height();

// 3. APLICAÇÃO GLOBAL AUTOMÁTICA
// Ajusta a Janela, a Superfície do Jogo e a GUI para a resolução do PC do usuário
window_set_size(_largura_monitor, _altura_monitor);
surface_resize(application_surface, _largura_monitor, _altura_monitor);
display_set_gui_size(_largura_monitor, _altura_monitor);

// 4. ATIVA A TELA CHEIA NATIVA
window_set_fullscreen(true);

// 5. CENTRALIZA A JANELA (Para segurança caso o usuário saia do fullscreen depois)
window_center();

// 6. ÁUDIO GLOBAL EM 100%
audio_master_gain(1.0);