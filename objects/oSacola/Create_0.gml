event_inherited();   // pega o "material" padrão do oEnemy

// ============================================================
//  SACOLA — lixo voando pelo mapa.
//
//  NÃO causa dano nenhum no player. Ela só atravessa a tela
//  flutuando. Mas PODE ser destruída (é filha do oEnemy, então
//  a arma do player acerta ela normalmente).
//
//  O sprite sacola_spr tem 3 frames em loop: 1-2-3-1-2-3...
//  que é a sacola balançando no vento.
//
//  Este aqui é o objeto PAI. Quem nasce de verdade são os filhos
//  oSacolaPequena e oSacolaGrande — eles só trocam alguns números.
// ============================================================


// ---- encaixe no sistema de dano do player (scr_try_hit_enemy) ----
material        = "plastico";   // o arpão rasga ela fácil
hp              = 1;            // um toque e já era
hittable        = true;
invuln_time     = 10;
invuln_timer    = 0;
hit_flash_timer = 0;

// O scr_try_hit_enemy olha 'phase' e 'state' quando a vida zera.
// Com phase = 2 ele cai direto no ramo de morte e liga state = "dying".
phase          = 2;
state          = "voando";
death_duration = 18;
death_timer    = 0;


// ---- aparência ----
depth       = -10;                      // na frente do cenário
tamanho     = 1;                        // os filhos sobrescrevem
image_speed = random_range(0.8, 1.2);   // cada sacola balança num ritmo


// ---- voo ----
dir       = choose(-1, 1);  // pra que lado ela atravessa (o spawner manda)
veloc     = 1.6;            // velocidade horizontal
amplitude = 18;             // altura do sobe-e-desce
vel_onda  = 2.5;            // graus por frame do sobe-e-desce
deriva    = 0;              // sobe (-) ou afunda (+) devagar o tempo todo
fase      = random(360);    // cada uma começa num ponto diferente da onda

y_base = y;                 // a linha em volta da qual ela oscila

vida = 60 * 30;             // segurança: some depois de 30s, aconteça o que acontecer
