// Bola de fogo cuspida pelo Cagliostro na fase 2.
// direction e speed são definidos por quem cria (oCagliostro).
life = 450; // atravessa a arena inteira (boss fica no extremo direito)
image_speed = 1; // usa a velocidade do próprio sprite (2 frames piscando)
fire_scale = 2.2;
image_xscale = fire_scale;
image_yscale = fire_scale;

// O sprite foi desenhado apontando para a ESQUERDA; se no jogo ele
// aparecer voando de costas, troque para 0.
sprite_angle_offset = 180;
