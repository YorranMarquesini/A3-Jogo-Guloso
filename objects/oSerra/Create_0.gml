// SERRA GIRATÓRIA
// Coloque a serra dentro de um oSerraArea (estique o retângulo laranja na
// room): ela vai e volta entre as bordas da área. Sem área ela fica parada
// no lugar, mas continua girando e machucando.
//
// Variable Definitions (editáveis na room):
//   move_speed - pixels por frame
//   move_axis  - "y" (sobe/desce: chão ou parede) ou "x" (vai para os lados)
//   start_dir  - 1 = começa descendo/indo para a direita, -1 = o contrário
//   damage     - dano por contato
//   grupo      - o oFactorySign com o mesmo grupo desliga esta serra
//
// Frame 0 do spr_cerra = serra parada; frames 0..5 = animação girando.

active = true;
initialized = false; // limites calculados no 1º Step (depois da creation code)
move_dir = sign(start_dir);
if (move_dir == 0) move_dir = 1;
area = noone;
min_pos = 0;
max_pos = 0;

image_index = 0;
image_speed = 1; // usa a velocidade definida no sprite

desligar = function() {
    if (!active) return;
    active = false;
    image_index = 0;
    image_speed = 0;

    // Faíscas de desligamento.
    repeat (8) {
        var _p = instance_create_depth(x, y, depth - 1, oHitParticle);
        var _a = random(360);
        var _s = random_range(1, 3);
        _p.dir_x = lengthdir_x(_s, _a);
        _p.dir_y = lengthdir_y(_s, _a);
        _p.color = choose(c_yellow, c_white, c_orange);
        _p.radius = random_range(2, 5);
        _p.fade_speed = 0.07;
    }
};
