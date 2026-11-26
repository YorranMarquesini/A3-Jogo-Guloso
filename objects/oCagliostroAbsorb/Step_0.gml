prev_x = x;
prev_y = y;

// Fade in ao surgir do ar.
image_alpha = min(1, image_alpha + 0.12);

var _dist = point_distance(x, y, target_x, target_y);
spd = min(max_spd, spd + accel);

if (_dist <= spd + 6) {
    instance_destroy();
    exit;
}

var _dir = point_direction(x, y, target_x, target_y);
x += lengthdir_x(spd, _dir);
y += lengthdir_y(spd, _dir);

// Encolhe conforme chega perto, como se fosse absorvida.
radius = max(1.5, radius * 0.985);
