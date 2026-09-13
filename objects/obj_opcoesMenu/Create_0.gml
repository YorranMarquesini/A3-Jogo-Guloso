// ============================================================
//  Configuração global de tela — roda uma vez, na primeira sala.
//  Este objeto é Persistent, então sobrevive à troca de salas e
//  continua vigiando a resolução no End Step.
// ============================================================

// 1. Evita instâncias duplicadas ao trocar de sala
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

// 2. TELA INTERNA NA RESOLUÇÃO BASE
// Repare: NÃO usamos mais display_get_width() aqui.
// O monitor decide o tamanho da JANELA — não quanto do jogo aparece.
// Quem decide isso é BASE_WIDTH/BASE_HEIGHT, lá no scr_config.
screen_apply_base();

// 3. TAMANHO DA JANELA quando NÃO estiver em tela cheia
window_set_size(BASE_WIDTH, BASE_HEIGHT);
window_center();

// 4. ABRE EM TELA CHEIA
window_set_fullscreen(false);

// 5. ÁUDIO GLOBAL EM 100%
audio_master_gain(1.0);
