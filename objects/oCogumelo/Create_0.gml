event_inherited();   // pega o "material" padrão do oEnemy

// ============================================================
//  COGUMELO AZUL — inimigo PARADO que expele uma nuvem de gás.
//
//  O sprite cogumelo_spr tem 3 frames:
//     0  cogumeloazul_1   boca fechada, quietinho
//     1  cogumeloazul_2   enchendo, boca abrindo
//     2  cogumeloazul_3   cheio, boca escancarada -> sai o gás
//
//  Ciclo: parado -> enchendo -> cheio -> SOLTA O GÁS -> descanso -> parado
//
//  Ele não anda e não vira de lado: fica plantado onde você colocar.
//  Quem machuca é a nuvem (oGasNuvem), não o cogumelo em si.
//
//  Este é o objeto PAI. Quem você coloca na sala são os filhos
//  oCogumeloPequeno e oCogumeloGrande.
// ============================================================


// ---- encaixe no sistema de dano do player (scr_try_hit_enemy) ----
material        = "organico";   // cogumelo é orgânico: a tesoura causa o dobro
hp              = 3;
hittable        = true;
invuln_time     = 20;
invuln_timer    = 0;
hit_flash_timer = 0;

// O scr_try_hit_enemy olha 'phase' e 'state' quando a vida zera.
// Com phase = 2 ele cai direto no ramo de morte e liga state = "dying".
phase          = 2;
state          = "parado";
death_duration = 26;
death_timer    = 0;


// ---- animação controlada na mão (cada estado escolhe o frame) ----
image_speed = 0;
image_index = 0;


// ---- percepção ----
sight_range  = 280;   // distância horizontal pra acordar
sight_height = 180;   // diferença vertical máxima pra "sentir" o player


// ---- tempos do ciclo, em frames (o jogo roda a 60) ----
tempo_enchendo = 26;   // frame 1 — é o aviso: dá pra sair de perto
tempo_cheio    = 18;   // frame 2 — prestes a soltar
tempo_soltando = 22;   // segura a boca aberta depois de soltar
tempo_descanso = 80;   // fecha a boca e respira antes de repetir
state_timer    = 0;


// ---- a nuvem de gás ----
gas_tamanho = 1;     // multiplicador do tamanho da nuvem
gas_dano    = 1;     // dano por "mordida" (ele repete enquanto você fica dentro)
gas_vida    = 110;   // quantos frames a nuvem dura
// A que altura a nuvem nasce. Os dois valores são multiplicados pela
// ALTURA REAL do cogumelo na tela, então o filho grande solta a nuvem
// mais longe que o pequeno sem você precisar ajustar nada aqui.
gas_altura_rel = 0.70;   // fração da altura do cogumelo (0.5 = meio do corpo)
gas_folga      = 10;     // folga extra em pixels, também proporcional
