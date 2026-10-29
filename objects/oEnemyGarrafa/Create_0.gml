event_inherited();   // pega o "material" padrão do oEnemy

// ============================================================
//  GARRAFA — inimigo parado que cospe a própria tampa.
//
//  O sprite garrafa_spr tem 4 frames, um por etapa do ciclo:
//     0  Garrafa_1   parada, ainda não viu o player
//     1  Garrafa_2   preparando o ataque
//     2  Garrafa_3   prestes a soltar
//     3  Garrafa_4   soltou (a tampa sai voando)
//
//  O ciclo é: idle -> windup -> aim -> shoot -> cooldown -> idle
// ============================================================


// ---- encaixe no sistema de dano do player (scr_try_hit_enemy) ----
material        = "plastico";   // o arpão causa o dobro de dano nela
hp              = 3;
hittable        = true;
invuln_time     = 20;           // frames invencível depois de apanhar
invuln_timer    = 0;
hit_flash_timer = 0;

// O scr_try_hit_enemy foi escrito pensando no boss: quando a vida zera
// ele olha 'phase' e 'state'. Com phase = 2 ele cai direto no ramo de
// morte, que liga state = "dying" e death_timer = death_duration.
// É esse estado que o Step trata lá embaixo.
phase          = 2;
state          = "idle";
death_duration = 30;
death_timer    = 0;


// ---- animação controlada na mão (cada estado escolhe o frame) ----
image_speed = 0;
image_index = 0;


// ---- pra que lado ela aponta ----
// ATENÇÃO: a arte foi desenhada apontando pra ESQUERDA.
// Por isso o espelhamento é invertido: image_xscale = -facing.
facing = -1;   // -1 = esquerda, +1 = direita


// ---- percepção ----
sight_range  = 520;   // distância horizontal pra acordar
sight_height = 200;   // diferença vertical máxima pra "enxergar"


// ---- tempos do ciclo, em frames (o jogo roda a 60) ----
windup_time   = 24;   // frame 1 — telegrafa, dá tempo do player reagir
aim_time      = 18;   // frame 2
shoot_hold    = 20;   // frame 3, logo depois do disparo
cooldown_time = 50;   // volta pro frame 0 e respira
state_timer   = 0;


// ---- disparo ----
tampa_speed    = 7;
contact_damage = 1;   // dano de encostar na garrafa

// de onde a tampa sai: a boca da garrafa no frame 3,
// medida a partir da origem do sprite (que fica na base dela)
muzzle_dx = 34;    // pra frente, no sentido pra onde ela aponta
muzzle_dy = -46;   // pra cima
