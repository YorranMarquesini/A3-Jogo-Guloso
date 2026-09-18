function scr_weapon(_type) {
    if (!variable_global_exists("owned_weapons")) {
        global.owned_weapons = [];
        global.current_weapon_index = -1;
    }

    // Só adiciona se ainda não tiver essa arma
    var _already_has = false;
    for (var _i = 0; _i < array_length(global.owned_weapons); _i++) {
        if (global.owned_weapons[_i] == _type) {
            _already_has = true;
            break;
        }
    }

    if (!_already_has) {
        array_push(global.owned_weapons, _type);
        global.current_weapon_index = array_length(global.owned_weapons) - 1; // equipa a nova automaticamente
    }

    scr_refresh_equipped_weapon();
}

function scr_take_weapon(_type) {
    if (!variable_global_exists("owned_weapons")) return;

    for (var _i = 0; _i < array_length(global.owned_weapons); _i++) {
        if (global.owned_weapons[_i] == _type) {
            array_delete(global.owned_weapons, _i, 1);
            break;
        }
    }

    if (array_length(global.owned_weapons) == 0) {
        global.current_weapon_index = -1;
    } else {
        global.current_weapon_index = clamp(global.current_weapon_index, 0, array_length(global.owned_weapons) - 1);
    }

    scr_refresh_equipped_weapon();
}

function scr_switch_weapon(_dir) {
    if (!variable_global_exists("owned_weapons")) return;

    var _count = array_length(global.owned_weapons);
    if (_count <= 1) return; // só 1 (ou 0) arma, não tem pra onde trocar

    global.current_weapon_index = (global.current_weapon_index + _dir + _count) mod _count;
    scr_refresh_equipped_weapon();
}

function scr_refresh_equipped_weapon() {
    if (!instance_exists(oPlayer)) return;

    with (oPlayer) {
        if (array_length(global.owned_weapons) == 0) {
            has_weapon = false;
            weapon_type = "";
            weapon_sprite = noone;
        } else {
            has_weapon = true;
            weapon_type = global.owned_weapons[global.current_weapon_index];
            weapon_sprite = scr_get_weapon_sprite(weapon_type);
        }
    }
}