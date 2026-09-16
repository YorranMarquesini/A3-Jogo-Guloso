function scr_get_weapon_damage(_weapon_type, _target_material) {
    var _base_damage = 1;

    // Tabela de multiplicadores: arma x material
    var _multiplier = 1;

    switch (_weapon_type) {
        case "tesoura":
            if (_target_material == "organico") _multiplier = 2;
            else if (_target_material == "metal") _multiplier = 0.5;
            break;

        case "arpao":
            if (_target_material == "plastico") _multiplier = 2;
            else if (_target_material == "organico") _multiplier = 0.75;
            break;
    }

    return _base_damage * _multiplier;
}