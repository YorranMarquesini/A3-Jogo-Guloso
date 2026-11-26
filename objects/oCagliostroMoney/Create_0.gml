// Nota de dinheiro que cai durante a fase 2 do Cagliostro (só visual, sem dano).
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
