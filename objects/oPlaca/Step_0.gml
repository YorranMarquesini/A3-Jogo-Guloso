if (message_timer > 0) message_timer--;

var _player = instance_find(oPlayer, 0);
var _cx = x + sprite_width * abs(image_xscale) * 0.5;
var _cy = y + sprite_height * abs(image_yscale) * 0.55;
player_near = instance_exists(_player) && point_distance(_cx, _cy, _player.x, _player.y) <= 105;

if (player_near && !activated && keyboard_check_pressed(ord("E"))) {
    activated = true;

    var _total_signs = instance_number(oPlaca);
    var _read_signs = 0;
    with (oPlaca) {
        if (activated) _read_signs++;
    }

    message_line_1 = "A AGUA RESPONDEU AO SINAL.";
    message_line_2 = "PROGRESSO: " + string(_read_signs) + "/" + string(_total_signs);

    if (_read_signs == _total_signs - 1) {
        var _chosen_door = noone;

        // A porta espelhada em X tem prioridade, como montado na room.
        with (oDoor) {
            if (image_xscale < 0 && !instance_exists(_chosen_door)) {
                _chosen_door = id;
            }
        }

        // Segurança para a room continuar funcionando mesmo sem flip:
        // nesse caso abre a porta posicionada mais à esquerda.
        if (!instance_exists(_chosen_door)) {
            var _left_x = 1000000000;
            with (oDoor) {
                if (x < _left_x) {
                    _left_x = x;
                    _chosen_door = id;
                }
            }
        }

        if (instance_exists(_chosen_door)) {
            with (_chosen_door) instance_destroy();
            message_line_1 = "UM SELO SE DESFEZ.";
            message_line_2 = "A PASSAGEM ESQUERDA FOI ABERTA.";
        } else {
            message_line_1 = "TRES SINAIS DESPERTARAM.";
            message_line_2 = "FALTA APENAS UM.";
        }
    }

    if (_read_signs >= _total_signs) {
        var _doors_left = instance_number(oDoor);
        if (_doors_left > 0) {
            with (oDoor) instance_destroy();
            message_line_1 = "TODOS OS SINAIS DESPERTARAM.";
            message_line_2 = "A PASSAGEM FINAL FOI ABERTA.";
        } else {
            message_line_1 = "TODOS OS SINAIS DESPERTARAM.";
            message_line_2 = "";
        }
    }

    message_timer = message_duration;
}

