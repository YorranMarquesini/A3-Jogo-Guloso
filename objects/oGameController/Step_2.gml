// ==========================================
// F11
// ==========================================

if (keyboard_check_pressed(fullscreen_key))
{
    window_set_fullscreen(
        !window_get_fullscreen()
    );
}


// ==========================================
// TAMANHO REAL DA JANELA
// ==========================================

var _window_w = window_get_width();
var _window_h = window_get_height();


// ==========================================
// O VIEWPORT OCUPA TODA A JANELA
// ==========================================

view_set_xport(0, 0);
view_set_yport(0, 0);

view_set_wport(0, _window_w);
view_set_hport(0, _window_h);