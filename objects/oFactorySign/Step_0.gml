var _pad = scr_gamepad_slot();

if (message_timer > 0) message_timer--;

var _player = instance_find(oPlayer, 0);
var _cx = (bbox_left + bbox_right) * 0.5;
var _cy = (bbox_top + bbox_bottom) * 0.5;
player_near = instance_exists(_player) && point_distance(_cx, _cy, _player.x, _player.y) <= 80;

if (player_near && !activated && controls_read(Bind.interact, _pad)) {
    activated = true;
    message_timer = message_duration;
    image_speed = 0;
    image_index = 0;

    var _grupo = grupo;
    with (oSerra) {
        if (grupo == _grupo) desligar();
    }
}
