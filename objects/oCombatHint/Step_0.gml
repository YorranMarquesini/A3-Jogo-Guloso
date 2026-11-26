var _pad = scr_gamepad_slot();
near_player = instance_exists(oPlayer) && point_distance(x, y, oPlayer.x, oPlayer.y - 24) <= 102;
if (!near_player || instance_exists(obj_dialogo)) show_hint = false;
else if (controls_read(Bind.interact, _pad)) show_hint = !show_hint;
