// --- ROLAGEM AUTOMÁTICA ---
pos_y -= velocidade;

// --- ENTRADAS PARA VOLTAR AO MENU ---
var _voltar_esc    = keyboard_check_pressed(vk_escape);
var _voltar_enter  = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _voltar_clique = mouse_check_button_pressed(mb_left);

// Se o texto subir tudo e sumir no topo, volta ao menu automaticamente
var _limite_topo = -800; // Distância negativa limite
var _texto_sumiu = (pos_y < _limite_topo);

// Se pressionar qualquer botão ou o texto terminar, retorna ao rm_menu
if (_voltar_esc || _voltar_enter || _voltar_clique || _texto_sumiu) {
    room_goto(rm_menu);
}