// ---- timers do sistema de dano ----
if (invuln_timer > 0)    invuln_timer--;
if (hit_flash_timer > 0) hit_flash_timer--;


// ============================================================
//  DESTRUÍDA
//  Quem liga este estado é o scr_try_hit_enemy, quando a vida zera.
// ============================================================
if (state == "dying") {
    death_timer--;

    // murcha e some
    var _t = max(death_timer / death_duration, 0);
    image_alpha  = _t;
    image_xscale = dir * tamanho * _t;
    image_yscale = tamanho * _t;

    if (death_timer <= 0) instance_destroy();
    exit;
}


// ============================================================
//  VOANDO
// ============================================================
fase   += vel_onda;
y_base += deriva;

x += dir * veloc;
y  = y_base + dsin(fase) * amplitude;

image_angle = dsin(fase) * 10;   // balança de leve

// A arte foi desenhada com as alças à esquerda — que é como a sacola
// fica quando vai pra DIREITA (as alças ficam arrastando atrás).
// Indo pra esquerda, espelha. Se ficar ao contrário no seu jogo,
// troque o sinal aqui: image_xscale = -dir * tamanho;
image_xscale = dir * tamanho;
image_yscale = tamanho;


// ============================================================
//  SUMIR
//  Sem isto as sacolas iam se acumulando pra sempre na memória.
// ============================================================
vida--;
if (vida <= 0) {
    instance_destroy();
    exit;
}

var _margem = 500;
var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);

if (x < _vx - _margem || x > _vx + _vw + _margem
 || y < _vy - _margem || y > _vy + _vh + _margem) {
    instance_destroy();
}
