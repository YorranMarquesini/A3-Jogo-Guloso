x += dir_x * spd;
y += dir_y * spd;
spd *= 0.9; // desacelera

image_alpha -= fade_speed;
if (image_alpha <= 0) {
    instance_destroy();
}