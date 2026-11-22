idade++;


// ---- gs_1 entra, depois vira gs_2 ----
image_index = (idade < dur_frame1) ? 0 : 1;


// ---- o gás sobe devagar e vai inchando um tiquinho ----
y -= subida;

var _crescimento = 1 + (idade / dur_total) * 0.18;
image_xscale = tamanho * _crescimento;
image_yscale = tamanho * _crescimento;


// ---- aparece rápido, some devagar ----
if (idade < dur_entrada) {
    image_alpha = idade / dur_entrada;
} else if (idade > inicio_fade) {
    image_alpha = max(1 - (idade - inicio_fade) / max(dur_total - inicio_fade, 1), 0);
} else {
    image_alpha = 1;
}


// ============================================================
//  DANO CONTÍNUO
//
//  O segredo está em chamar isto TODO FRAME. O scr_damage_player
//  ignora enquanto o player ainda está invencível, e volta a
//  machucar no instante em que os i-frames dele acabam.
//  Resultado: ficar parado dentro da nuvem dói de novo e de novo.
// ============================================================
if (instance_exists(oPlayer) && place_meeting(x, y, oPlayer)) {
    scr_damage_player(dano, x);
}


// ---- fim da nuvem ----
if (idade >= dur_total) instance_destroy();
