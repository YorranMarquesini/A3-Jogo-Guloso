// Cada nota participa de um único sorteio ao se aproximar do jogador.
proximity_checked = false;
explosive = false;
blink_steps = 0;
fall_speed = random_range(3.2, 5.0);
sway_amount = random_range(0.6, 1.6);   // balanço lateral, como papel caindo
sway_speed = random_range(0.05, 0.09);
sway_phase = random(pi * 2);
spin_speed = random_range(-4, 4);
life = 600;

image_speed = 0.15;
image_index = irandom(image_number - 1);
image_angle = random(360);
image_xscale = 1.6;
image_yscale = 1.6;
