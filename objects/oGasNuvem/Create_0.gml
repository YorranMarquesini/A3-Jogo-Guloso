// ============================================================
//  NUVEM DE GÁS — o ataque do cogumelo.
//
//  O sprite gas_spr tem 2 frames: gs_1 (fechando ainda) e
//  gs_2 (já aberta). Ela ENTRA no frame 1, passa pro 2, e fica
//  no 2 até sumir — exatamente a sequência que você descreveu.
//
//  Machuca CONTINUAMENTE: enquanto o player estiver dentro dela,
//  toma dano de novo toda vez que a invencibilidade acaba.
//
//  Não é filha do oEnemy de propósito: gás não se destrói na pancada.
// ============================================================

depth = -90;         // na frente do cogumelo, atrás dos projéteis

image_speed = 0;     // a troca de frame é na mão, no Step
image_index = 0;
image_alpha = 0;     // entra aparecendo

// ---- quem criou sobrescreve estes ----
tamanho     = 1;
dano        = 1;
dur_total   = 110;   // vida inteira da nuvem, em frames
inicio_fade = 70;    // a partir daqui começa a sumir
dono        = noone;

// ---- fixos ----
dur_frame1 = 14;     // quanto tempo fica no gs_1 antes de abrir
dur_entrada = 8;     // frames aparecendo
subida     = 0.12;   // gás sobe bem devagar
idade      = 0;

image_xscale = tamanho;
image_yscale = tamanho;
