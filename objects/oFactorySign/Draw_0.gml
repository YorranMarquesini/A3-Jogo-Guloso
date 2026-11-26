draw_self();

var _cx = (bbox_left + bbox_right) * 0.5;
var _top = bbox_top - 20;
var _text = "";

if (player_near && !activated) _text = controls_label(Bind.interact) + " - DESLIGAR SERRAS";
else if (message_timer > 0) _text = "SERRAS DESLIGADAS";

if (_text != "") {
    var _alpha = (activated) ? clamp(message_timer / 24, 0, 1) : 1;

    draw_set_font(fnt_dialogo);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _hw = string_width(_text) * 0.5 + 12;
    draw_set_alpha(0.86 * _alpha);
    draw_set_colour(c_black);
    draw_rectangle(_cx - _hw, _top - 20, _cx + _hw, _top + 20, false);
    draw_set_alpha(_alpha);
    draw_set_colour(make_color_rgb(150, 60, 40));
    draw_rectangle(_cx - _hw, _top - 20, _cx + _hw, _top + 20, true);
    draw_set_colour(c_black);
    draw_text(_cx + 2, _top + 2, _text);
    draw_set_colour(make_color_rgb(255, 228, 200));
    draw_text(_cx, _top, _text);

    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
