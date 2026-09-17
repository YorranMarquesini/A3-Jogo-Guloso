function scr_grant_permanent_heart() {
    if (!variable_global_exists("bonus_hearts")) {
        global.bonus_hearts = 0;
    }
    global.bonus_hearts += 1;

    if (instance_exists(oPlayer)) {
        oPlayer.max_hp += 1;
        oPlayer.hp += 1; // já cura o coração novo também
    }
}