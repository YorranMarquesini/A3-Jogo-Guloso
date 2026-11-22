// ============================================================
//  SUPER PULO — a rede de segurança lá embaixo da sala do boss.
//
//  Fica FORA DA TELA, abaixo da plataforma mais baixa, e é invisível.
//  Se o player cair, ele encosta aqui e é cuspido pra cima com força
//  suficiente pra voltar pro meio das plataformas.
//
//  Usa o ground_1_spr só como máscara de colisão — não é um oGround,
//  então o player NÃO fica em pé em cima dele.
// ============================================================

visible = false;

// Força do arremesso. A gravidade do player é 0.25, então a altura
// que ele ganha é forca² / (2 * 0.25)  ->  com -16 sobe uns 512px,
// o bastante pra passar da plataforma do meio (y = 736).
forca = -16;

// impede disparar duas vezes no mesmo toque
cooldown = 0;
