var _pad = scr_gamepad_slot();

var player = instance_find(oPlayer, 0);

if (player != noone) {
    var dist = point_distance(x, y, player.x, player.y);
    
    // Só permite abrir um novo diálogo se a caixa NÃO existir
    if (dist <= distancia_interacao && !instance_exists(obj_dialogo)) {
        
        if (controls_read(Bind.interact, _pad)) {
            var falas = [
                "Oi, eu sou o Tartaruga Canudo!",
                "Estou procurando ajuda para limpar este rio...",
                "Você poderia me ajudar a coletar o lixo?"
            ];

            var audios_fala = array_create(array_length(falas), snd_tartaruga_voz);
            scr_iniciar_dialogo("Tartaruga Canudo", falas, spr_retrato_tartaruga, audios_fala, snd_tartaruga_meme);
        }
    }
}
