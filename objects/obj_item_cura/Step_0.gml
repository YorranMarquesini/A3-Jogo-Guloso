if (place_meeting(x, y, oPlayer)) {
    // 1. Atualiza no player atual
    oPlayer.hp = min(oPlayer.hp + 1, oPlayer.hp_max);
    oPlayer.poluicao = max(oPlayer.poluicao - 20, 0);
    
    // 2. Salva nas globais para a próxima sala
    global.player_hp = oPlayer.hp;
    global.player_poluicao = oPlayer.poluicao;
    
    // Destrói o item
    instance_destroy();
}