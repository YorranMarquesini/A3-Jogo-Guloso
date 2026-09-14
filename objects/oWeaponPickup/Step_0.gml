if (place_meeting(x, y, oPlayer)) {
    with (oPlayer) {
        has_weapon = true;
        weapon_type = other.weapon_type;

        // Define o sprite da arma baseado no tipo
        if (weapon_type == "arpao") {
            weapon_sprite = arpao_spr;
        } else if (weapon_type == "tesoura") {
            weapon_sprite = tesoura_spr;
        }
    }
    instance_destroy(); // remove o pickup do chão
}