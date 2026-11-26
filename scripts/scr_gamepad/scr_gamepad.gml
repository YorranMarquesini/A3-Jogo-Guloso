enum Bind { left, right, up, down, jump, dash, attack, heavy, toss, weapon, interact, pause, confirm, back, count }

function controls_init() {
    if (variable_global_exists("controls_keyboard")) return;
    global.controls_labels = ["Esquerda", "Direita", "Cima", "Baixo", "Pular", "Dash", "Ataque", "Ataque forte", "Arremessar", "Trocar arma", "Interagir", "Pausar", "Confirmar", "Voltar"];
    global.controls_default_keys = [ord("A"), ord("D"), ord("W"), ord("S"), vk_space, vk_shift, -mb_left, ord("R"), -mb_right, ord("Q"), ord("E"), vk_enter, vk_enter, vk_escape];
    global.controls_default_pad = [gp_padl, gp_padr, gp_padu, gp_padd, gp_face1, gp_face2, gp_face3, gp_face4, gp_shoulderrb, gp_shoulderl, gp_shoulderr, gp_start, gp_face1, gp_face2];
    global.controls_buttons = [gp_face1, gp_face2, gp_face3, gp_face4, gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb, gp_select, gp_start, gp_stickl, gp_stickr, gp_padu, gp_padd, gp_padl, gp_padr];
    global.controls_button_labels = ["A", "B", "X", "Y", "LB", "RB", "LT", "RT", "Select", "Start", "L3", "R3", "D-pad cima", "D-pad baixo", "D-pad esq.", "D-pad dir."];
    global.controls_keyboard = [];
    global.controls_pad = [];
    global.controls_using_pad = false;
    global.controls_stick = 0;
    global.controls_mouse_x = window_mouse_get_x();
    global.controls_mouse_y = window_mouse_get_y();
    ini_open("controles.ini");
    for (var i = 0; i < Bind.count; i++) {
        var _key = ini_read_real("teclado", string(i), global.controls_default_keys[i]);
        var _button = ini_read_real("controle", string(i), global.controls_default_pad[i]);
        global.controls_keyboard[i] = controls_key_valid(_key) ? _key : global.controls_default_keys[i];
        global.controls_pad[i] = array_contains(global.controls_buttons, _button) ? _button : global.controls_default_pad[i];
    }
    ini_close();
}

function controls_key_valid(_k) {
    return (_k >= ord("0") && _k <= ord("9")) || (_k >= ord("A") && _k <= ord("Z"))
        || (_k >= vk_f1 && _k <= vk_f12 && _k != vk_f11)
        || array_contains([vk_space, vk_shift, vk_control, vk_alt, vk_enter, vk_escape, vk_tab, vk_backspace, vk_up, vk_down, vk_left, vk_right, -mb_left, -mb_right, -mb_middle], _k);
}

function controls_key_name(_k) {
    switch (_k) {
        case vk_space: return "Espaco";
        case vk_shift: return "Shift";
        case vk_control: return "Ctrl";
        case vk_alt: return "Alt";
        case vk_enter: return "Enter";
        case vk_escape: return "Esc";
        case vk_tab: return "Tab";
        case vk_backspace: return "Backspace";
        case vk_left: return "Seta esq.";
        case vk_right: return "Seta dir.";
        case vk_up: return "Seta cima";
        case vk_down: return "Seta baixo";
        case -mb_left: return "Mouse 1";
        case -mb_right: return "Mouse 2";
        case -mb_middle: return "Mouse 3";
    }
    if (_k >= vk_f1 && _k <= vk_f12) return "F" + string(_k - vk_f1 + 1);
    return chr(_k);
}

function controls_label(_action, _pad_device = undefined) {
    controls_init();
    if (is_undefined(_pad_device)) _pad_device = global.controls_using_pad;
    if (!_pad_device) return controls_key_name(global.controls_keyboard[_action]);
    return global.controls_button_labels[array_get_index(global.controls_buttons, global.controls_pad[_action])];
}

function controls_poll_device(_slot) {
    var _mx = window_mouse_get_x(), _my = window_mouse_get_y();
    if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left)
    || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle)
    || _mx != global.controls_mouse_x || _my != global.controls_mouse_y || _slot < 0) global.controls_using_pad = false;
    global.controls_mouse_x = _mx;
    global.controls_mouse_y = _my;
    var _stick = 0;
    if (_slot >= 0) {
        var _ax = gamepad_axis_value(_slot, gp_axislh), _ay = gamepad_axis_value(_slot, gp_axislv);
        _stick = (abs(_ax) > 0.35 ? sign(_ax) : 0) + 3 * (abs(_ay) > 0.35 ? sign(_ay) : 0);
        if (_stick != 0 && _stick != global.controls_stick) global.controls_using_pad = true;
        for (var i = 0; i < array_length(global.controls_buttons); i++) {
            if (gamepad_button_check_pressed(_slot, global.controls_buttons[i])) {
                global.controls_using_pad = true;
                break;
            }
        }
    }
    global.controls_stick = _stick;
}

function scr_gamepad_slot() {
    controls_init();
    var _slot = -1;
    for (var i = 0; i < gamepad_get_device_count(); i++) {
        if (gamepad_is_connected(i)) { _slot = i; break; }
    }
    controls_poll_device(_slot);
    return _slot;
}

enum BindState { pressed, held, released }

function controls_key(_key, _state) {
    if (_key < 0) {
        switch (_state) {
            case BindState.held: return mouse_check_button(-_key);
            case BindState.released: return mouse_check_button_released(-_key);
            default: return mouse_check_button_pressed(-_key);
        }
    }
    switch (_state) {
        case BindState.held: return keyboard_check(_key);
        case BindState.released: return keyboard_check_released(_key);
        default: return keyboard_check_pressed(_key);
    }
}

function controls_read(_action, _slot, _state = BindState.pressed) {
    if (controls_key(global.controls_keyboard[_action], _state)) return true;
    if (_slot < 0) return false;
    var _button = global.controls_pad[_action];
    switch (_state) {
        case BindState.held: return gamepad_button_check(_slot, _button);
        case BindState.released: return gamepad_button_check_released(_slot, _button);
        default: return gamepad_button_check_pressed(_slot, _button);
    }
}

function controls_direction(_action, _arrow, _slot) {
    if (controls_read(_action, _slot, BindState.held)) return true;
    // Setas alternativas ficam livres assim que sao atribuidas a outra acao.
    return global.controls_keyboard[_action] == global.controls_default_keys[_action]
        && !array_contains(global.controls_keyboard, _arrow) && keyboard_check(_arrow);
}

function pad_directions(_slot) {
    var _ax = (_slot >= 0) ? gamepad_axis_value(_slot, gp_axislh) : 0;
    var _ay = (_slot >= 0) ? gamepad_axis_value(_slot, gp_axislv) : 0;
    if (!variable_instance_exists(id, "pad_last_x")) { pad_last_x = 0; pad_last_y = 0; }
    var _dx = (controls_direction(Bind.right, vk_right, _slot) || _ax > 0.35) - (controls_direction(Bind.left, vk_left, _slot) || _ax < -0.35);
    var _dy = (controls_direction(Bind.down, vk_down, _slot) || _ay > 0.35) - (controls_direction(Bind.up, vk_up, _slot) || _ay < -0.35);
    var _result = { dx: _dx, dy: _dy, press_x: (_dx != pad_last_x) * _dx, press_y: (_dy != pad_last_y) * _dy };
    pad_last_x = _dx; pad_last_y = _dy;
    return _result;
}

function controls_menu_space() {
    if (!keyboard_check_pressed(vk_space)) return false;
    for (var i = Bind.left; i <= Bind.down; i++) {
        if (global.controls_keyboard[i] == vk_space) return false;
    }
    return global.controls_keyboard[Bind.back] != vk_space;
}

function controls_editor_open() {
    controls_init();
    bindings_open = true;
    bindings_pad = global.controls_using_pad;
    bindings_row = 0;
    bindings_top = 0;
    bindings_capture = false;
    bindings_message = "";
}

function controls_editor_step(_slot, _dir) {
    var _h = display_get_gui_height(), _cx = display_get_gui_width() * 0.5;
    var _spacing = min(46, _h * 0.068);
    var _first = _h * 0.27;
    var _mx = device_mouse_x_to_gui(0), _my = device_mouse_y_to_gui(0);
    var _click = mouse_check_button_pressed(mb_left);
    var _footer_click = _click && abs(_mx - _cx) <= 290 && abs(_my - _h * 0.84) < _spacing * 0.5;
    if (bindings_capture) {
        if ((keyboard_check_pressed(vk_escape) && (bindings_pad || bindings_row != Bind.back + 1)) || _footer_click || (bindings_pad && _slot < 0)) {
            bindings_capture = false;
            bindings_message = "";
            return;
        }
        var _new = 0;
        if (bindings_pad) {
            for (var i = 0; i < array_length(global.controls_buttons); i++) {
                var _button = global.controls_buttons[i];
                if (gamepad_button_check_pressed(_slot, _button)) { _new = _button; break; }
            }
        } else {
            for (var _key = 2; _key <= vk_f12; _key++) {
                if (controls_key_valid(_key) && keyboard_check_pressed(_key)) { _new = _key; break; }
            }
            if (mouse_check_button_pressed(mb_left)) _new = -mb_left;
            if (mouse_check_button_pressed(mb_right)) _new = -mb_right;
            if (mouse_check_button_pressed(mb_middle)) _new = -mb_middle;
        }
        if (_new == 0) return;
        var _action = bindings_row - 1;
        var _map = bindings_pad ? global.controls_pad : global.controls_keyboard;
        for (var i = 0; i < Bind.count; i++) {
            // Confirmar e voltar pertencem aos menus, mas compartilham as direcoes.
            var _shared = i <= Bind.down || _action <= Bind.down || (i >= Bind.confirm) == (_action >= Bind.confirm);
            if (i != _action && _shared && _map[i] == _new) {
                bindings_message = "Em uso por " + global.controls_labels[i] + ". Escolha outro.";
                return;
            }
        }
        if (bindings_pad) global.controls_pad[_action] = _new;
        else global.controls_keyboard[_action] = _new;
        ini_open("controles.ini");
        ini_write_real(bindings_pad ? "controle" : "teclado", string(_action), _new);
        ini_close();
        bindings_capture = false;
        bindings_message = "";
        return;
    }
    if (controls_read(Bind.back, _slot) || _footer_click) { bindings_open = false; return; }
    var _change = _dir.press_y;
    if (mouse_wheel_down()) _change = 1;
    if (mouse_wheel_up()) _change = -1;
    bindings_row = clamp(bindings_row + _change, 0, Bind.count);
    var _visible = 8;
    bindings_top = clamp(bindings_top, max(0, bindings_row - _visible + 1), bindings_row);
    var _confirm = controls_read(Bind.confirm, _slot);
    if (_click && abs(_mx - _cx) <= 290) {
        var _index = round((_my - _first) / _spacing);
        if (_index >= 0 && _index < _visible && bindings_top + _index <= Bind.count) {
            bindings_row = bindings_top + _index;
            _confirm = true;
        }
    }
    if (_change != 0) bindings_message = "";
    if (bindings_row == 0 && (_dir.press_x != 0 || _confirm)) {
        bindings_pad = !bindings_pad;
        bindings_message = "";
    } else if (_confirm && bindings_row > 0) {
        if (bindings_pad && _slot < 0) bindings_message = "Conecte um controle.";
        else { bindings_capture = true; bindings_message = ""; }
    }
}

function controls_editor_draw() {
    var _w = display_get_gui_width(), _h = display_get_gui_height(), _cx = _w * 0.5;
    var _spacing = min(46, _h * 0.068);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(22, 28, 22));
    draw_rectangle(0, 0, _w, _h, false);
    draw_set_font(fnt_tutoras);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(228, 222, 175));
    draw_text_transformed(_cx, _h * 0.12, "CONTROLES", 1.8, 1.8, 0);
    draw_set_font(fnt_dialogo);
    draw_text(_cx, _h * 0.19, bindings_pad ? "JOYSTICK" : "TECLADO E MOUSE");
    for (var i = 0; i < 8 && bindings_top + i <= Bind.count; i++) {
        var _row = bindings_top + i;
        var _yy = _h * 0.27 + i * _spacing;
        draw_set_color(_row == bindings_row ? make_color_rgb(76, 83, 51) : make_color_rgb(42, 50, 39));
        draw_rectangle(_cx - 290, _yy - _spacing * 0.46, _cx + 290, _yy + _spacing * 0.46, false);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_text(_cx - 270, _yy, _row == 0 ? "Dispositivo" : global.controls_labels[_row - 1]);
        draw_set_halign(fa_right);
        draw_text(_cx + 270, _yy, _row == 0 ? (bindings_pad ? "< Joystick >" : "< Teclado >") :
            (bindings_capture && _row == bindings_row ? "..." : controls_label(_row - 1, bindings_pad)));
    }
    draw_set_halign(fa_center);
    var _hint = bindings_capture ? (bindings_pad ? "Aperte o novo botao" : "Aperte a nova tecla ou botao do mouse") :
        controls_label(Bind.up) + "/" + controls_label(Bind.down) + " navegar   -   " + controls_label(Bind.confirm) + " alterar";
    draw_text(_cx, _h * 0.77, bindings_message != "" ? bindings_message : _hint);
    draw_text(_cx, _h * 0.84, bindings_capture ? "[ Cancelar ]" : "[ Voltar ]");
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}

