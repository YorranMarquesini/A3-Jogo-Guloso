var _pad = scr_gamepad_slot();

scroll_y += scroll_speed;
if (controls_read(Bind.dash, _pad, BindState.held)) scroll_y += 2.2;
if (controls_read(Bind.back, _pad) || controls_read(Bind.confirm, _pad)) finish_credits();
if (scroll_y > 9400) finish_credits();
