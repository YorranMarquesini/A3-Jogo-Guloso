// Rastro curto na direção do movimento + núcleo.
draw_set_alpha(image_alpha * 0.45);
draw_set_color(color);
draw_line_width(prev_x - (x - prev_x) * 1.5, prev_y - (y - prev_y) * 1.5, x, y, radius * 0.9);
draw_set_alpha(image_alpha);
draw_circle(x, y, radius, false);
draw_set_alpha(1);
draw_set_color(c_white);
