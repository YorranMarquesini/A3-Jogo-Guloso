// Cancela a exibição se o oPlayer não existir ou se estiver no Menu
if (room == rm_menu) exit; // Troque 'rm_menu' pelo nome da sua sala de menu se for diferente
if (!instance_exists(oPlayer)) exit;

var _player = oPlayer;

// --- CONFIGURAÇÕES DE POSIÇÃO ---
var _margin_x = 20;
var _margin_y = 20;
var _heart_spacing = 36; 

// ==========================================
// 1. SISTEMA DE CORAÇÕES (VIDA)
// ==========================================
for (var i = 0; i < _player.hp_max; i++) {
    // Frame 0 = Cheio | Frame 1 = Vazio
    var _icon_index = (i < _player.hp) ? 0 : 1; 
    
    draw_sprite(spr_coracao, _icon_index, _margin_x + (i * _heart_spacing), _margin_y);
}

// ==========================================
// 2. BARRA DE POLUIÇÃO
// ==========================================
var _bar_x = _margin_x;
var _bar_y = _margin_y + 60;
var _bar_width = 160;
var _bar_height = 20;

var _poluicao_percent = clamp(_player.poluicao, 0, 100);

// Fundo BRANCO (Fica visível no espaço vazio quando a poluição diminui)
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);

// Preenchimento VERDE baseado na porcentagem de poluição
var _fill_width = (_poluicao_percent / 100) * _bar_width;
if (_fill_width > 0) {
    draw_set_color(c_lime);
    draw_set_alpha(1);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _fill_width, _bar_y + _bar_height, false);
}

// Borda da barra (Branca/Contorno)
draw_set_color(c_white);
draw_set_alpha(1);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, true);

// ==========================================
// 3. TEXTO DA POLUIÇÃO
// ==========================================
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);

// Usa o Asset de fonte criado
draw_set_font(fnt_hud);

var _text_x = _bar_x + (_bar_width / 2);
var _text_y = _bar_y + (_bar_height / 2);

draw_text(_text_x, _text_y, "POLUIÇÃO: " + string(round(_poluicao_percent)) + "%");

// --- RESETA AS CONFIGURAÇÕES PADRÃO DO GAMEMAKER ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);