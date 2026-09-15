var texto_completo = textos[pagina];
var _input_avancar = keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_left);

// 1. Enquanto o texto estiver sendo digitado
if (caractere_atual < string_length(texto_completo)) {
    caractere_atual += velocidade_texto;
    
    // Pula a digitacao (SKIP)
    if (_input_avancar) {
        caractere_atual = string_length(texto_completo);
    }
} 
// 2. Quando o texto termina de ser digitado
else {
    // Se o tempo ainda nao foi calculado para esta frase:
    if (tempo_espera_frames == -1) {
        var _duracao_segundos = tempo_padrao_sem_audio;
        
        // Se existir um audio valido para esta frase, pega a duracao exata dele em segundos
        if (array_length(audios) > pagina && audios[pagina] != noone) {
            _duracao_segundos = audio_sound_length(audios[pagina]);
        }
        
        // Converte os segundos em frames (ex: 3 segundos * 60 fps = 180 frames)
        tempo_espera_frames = ceil(_duracao_segundos * game_get_speed(gamespeed_fps));
    }
    
    // Regressao do tempo de espera
    if (tempo_espera_frames > 0) {
        tempo_espera_frames--;
    }
    
    // Quando o tempo do audio acaba OU o jogador aperta o botao de avancar
    if (tempo_espera_frames <= 0 || _input_avancar) {
        tempo_espera_frames = -1; // Reseta a contagem para a proxima frase
        
        // Para os audios atuais e avanca a pagina
        audio_stop_all();
        
        if (pagina < array_length(textos) - 1) {
            pagina++;
            caractere_atual = 0;
            
            // Toca o audio da nova frase
            if (array_length(audios) > pagina && audios[pagina] != noone) {
                audio_play_sound(audios[pagina], 1, false);
            }
        } else {
            // Fim dos dialogos
            instance_destroy();
        }
    }
}