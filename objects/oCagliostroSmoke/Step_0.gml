life--;
age++;
image_angle += 1.5;

// Nasce como uma nuvem grande junto ao chefe e encolhe suavemente antes de
// chegar ao jogador. Depois mantém apenas uma pulsação visual discreta.
var _shrink_progress = clamp(age / shrink_duration, 0, 1);
var _smooth_progress = _shrink_progress * _shrink_progress * (3 - 2 * _shrink_progress);
var _current_scale = lerp(start_scale, target_scale, _smooth_progress);
var _pulse = (_shrink_progress >= 1) ? sin(current_time / 140) * 0.06 : 0;
image_xscale = _current_scale + _pulse;
image_yscale = _current_scale + _pulse;

if (place_meeting(x, y, oPlayer)) {
    scr_damage_player(1, x);
    instance_destroy();
    exit;
}

if (life <= 0 || x < -256 || x > room_width + 256 || y < -256 || y > room_height + 256) instance_destroy();
