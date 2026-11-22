owner = noone;
returning = false;
// Percorre praticamente toda a largura da arena antes de voltar.
travel_timer = 190;
move_speed = 10;
direction = 180;
image_speed = 0.24;
image_xscale = 5.5;
image_yscale = 5.5;
hit_lock = 0;

if (instance_exists(oPlayer)) direction = point_direction(x, y, oPlayer.x, oPlayer.y);
