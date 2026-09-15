function scr_give_weapon(_type) {
    global.has_weapon = true;
    global.weapon_type = _type;

    switch (_type) {
        case "arpao":
            global.weapon_sprite = arpao_spr;
            break;
        case "tesoura":
            global.weapon_sprite = tesoura_spr;
            break;
    }

    if (instance_exists(oPlayer)) {
        oPlayer.has_weapon = global.has_weapon;
        oPlayer.weapon_type = global.weapon_type;
        oPlayer.weapon_sprite = global.weapon_sprite;
    }
}

function scr_take_weapon() {
    global.has_weapon = false;
    global.weapon_type = "";
    global.weapon_sprite = noone;

    if (instance_exists(oPlayer)) {
        oPlayer.has_weapon = false;
        oPlayer.weapon_type = "";
        oPlayer.weapon_sprite = noone;
    }
}