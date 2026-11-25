function scr_iniciar_dialogo(_nome, _falas, _portrait, _audios, _audio_final = noone) {
    if (!instance_exists(obj_dialogo)) {
        var _inst = instance_create_layer(0, 0, "Instances", obj_dialogo);
        
        with (_inst) {
            nome = _nome;
            textos = _falas;
            portrait = _portrait;
            audios = _audios;
            audio_final = _audio_final;
            
            pagina = 0;
            caractere_atual = 0;
            
            tocar_voz_pagina();
        }
    }
}
