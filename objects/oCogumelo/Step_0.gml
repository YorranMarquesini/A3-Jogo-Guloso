// ============================================================
//  COGUMELO AZUL — ciclo do gás
// ============================================================

// ---- timers do sistema de dano ----
if (invuln_timer > 0)    invuln_timer--;
if (hit_flash_timer > 0) hit_flash_timer--;


// ============================================================
//  MORRENDO
//  Quem liga este estado é o scr_try_hit_enemy, quando a vida zera.
// ============================================================
if (state == "dying") {
    death_timer--;
    image_index = 2;                 // morre de boca aberta
    image_alpha = max(death_timer / death_duration, 0);

    if (death_timer <= 0) instance_destroy();
    exit;
}


// ============================================================
//  O PLAYER CHEGOU PERTO?
// ============================================================
var _ve_player = false;

if (instance_exists(oPlayer)) {
    var _meu_cx = (bbox_left + bbox_right) * 0.5;
    var _meu_cy = (bbox_top  + bbox_bottom) * 0.5;
    var _plr_cx = (oPlayer.bbox_left + oPlayer.bbox_right) * 0.5;
    var _plr_cy = (oPlayer.bbox_top  + oPlayer.bbox_bottom) * 0.5;

    _ve_player = (abs(_plr_cx - _meu_cx) < sight_range)
              && (abs(_plr_cy - _meu_cy) < sight_height);
}


// ============================================================
//  CICLO
// ============================================================
var _nuvem = noone;

state_timer--;

switch (state) {

    case "parado":                 // === cogumeloazul_1 ===
        image_index = 0;
        if (_ve_player) {
            state       = "enchendo";
            state_timer = tempo_enchendo;
        }
        break;

    case "enchendo":               // === cogumeloazul_2 ===
        image_index = 1;
        if (state_timer <= 0) {
            state       = "cheio";
            state_timer = tempo_cheio;
        }
        break;

    case "cheio":                  // === cogumeloazul_3 ===
        image_index = 2;

        if (state_timer <= 0) {
            // ---- SOLTA O GÁS ----
            // A altura vem da bounding box, não de um número fixo:
            // bbox_bottom - bbox_top já é a altura do cogumelo NA TELA,
            // com a escala dele embutida. Então a nuvem se afasta mais
            // num cogumelo grande e menos num pequeno, sozinha — e
            // continua certa se um dia o sprite mudar de tamanho.
            var _altura = bbox_bottom - bbox_top;
            var _gas_y  = y - _altura * gas_altura_rel - gas_folga * image_yscale;

            _nuvem = instance_create_depth(x, _gas_y, depth - 1, oGasNuvem);

            _nuvem.tamanho     = gas_tamanho;
            _nuvem.dano        = gas_dano;
            _nuvem.dur_total   = gas_vida;
            _nuvem.inicio_fade = gas_vida * 0.6;
            _nuvem.dono        = id;

            state       = "soltando";
            state_timer = tempo_soltando;
        }
        break;

    case "soltando":               // segura a boca aberta logo depois
        image_index = 2;
        if (state_timer <= 0) {
            state       = "descanso";
            state_timer = tempo_descanso;
        }
        break;

    case "descanso":               // fecha a boca e respira
        image_index = 0;
        if (state_timer <= 0) {
            state = "parado";
        }
        break;
}

// Repare no que NÃO tem aqui: nada de hsp, vsp ou gravidade.
// Ele é plantado — fica exatamente onde você soltar no editor de salas.
