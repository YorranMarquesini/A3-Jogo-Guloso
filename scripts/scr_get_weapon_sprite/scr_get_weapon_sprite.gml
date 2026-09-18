function scr_get_weapon_sprite(_type) {
    switch (_type) {
        case "arpao":   return arpao_spr;
        case "tesoura": return tesoura_spr;
    }
    return noone;
}