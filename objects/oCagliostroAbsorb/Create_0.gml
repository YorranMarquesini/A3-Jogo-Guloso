// Partícula "sugada" pelo Cagliostro durante a transformação para a fase 2.
// Nasce longe dele, acelera em direção ao alvo e some ao chegar.
target_x = x;
target_y = y;
spd = random_range(1.5, 3.5);
accel = random_range(0.55, 0.9);
max_spd = random_range(22, 30);
radius = random_range(4, 9);
color = choose(c_white, c_red, make_color_rgb(255, 90, 70), make_color_rgb(255, 200, 120));
image_alpha = 0;
prev_x = x;
prev_y = y;
