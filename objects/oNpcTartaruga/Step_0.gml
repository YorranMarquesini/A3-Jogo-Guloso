var player = instance_find(oPlayer, 0);

if (player != noone) {
    var dist = point_distance(x, y, player.x, player.y);
    
    // Só permite abrir um novo diálogo se a caixa NÃO existir
    if (dist <= distancia_interacao && !instance_exists(obj_dialogo)) {
        
        if (keyboard_check_pressed(ord("E"))) {
            var falas = [
                "Oi, eu sou o Tartaruga Canudo!",
                "Estou procurando ajuda para limpar este rio...",
                "Você poderia me ajudar a coletar o lixo?"
            ];

            var audios_fala = [
                snd_tartaruga_fala1, 
                snd_tartaruga_fala2,
                snd_tartaruga_fala3
            ];

            scr_iniciar_dialogo("Tartaruga Canudo", falas, spr_retrato_tartaruga, audios_fala);
        }
    }
}