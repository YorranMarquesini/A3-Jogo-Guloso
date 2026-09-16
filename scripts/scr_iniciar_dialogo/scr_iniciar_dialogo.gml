function scr_iniciar_dialogo(_nome, _falas, _portrait, _audios) {
    if (!instance_exists(obj_dialogo)) {
        var _inst = instance_create_layer(0, 0, "Instances", obj_dialogo);
        
        with (_inst) {
            nome = _nome;
            textos = _falas;
            portrait = _portrait;
            audios = _audios;
            
            pagina = 0;
            caractere_atual = 0;
            
            // Toca o primeiro áudio se existir
            if (array_length(audios) > 0 && audios[0] != noone) {
                audio_play_sound(audios[0], 1, false);
            }
        }
    }
}