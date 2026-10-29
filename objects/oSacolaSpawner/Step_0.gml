timer--;
if (timer > 0) exit;

timer = irandom_range(intervalo_min, intervalo_max);


// ---- onde está a câmera agora ----
var _vx = camera_get_view_x(view_camera[0]);
var _vy = camera_get_view_y(view_camera[0]);
var _vw = camera_get_view_width(view_camera[0]);
var _vh = camera_get_view_height(view_camera[0]);


// ============================================================
//  1 ou 2 sacolas por leva — nunca mais que isso.
//
//  choose(1, 1, 2) = sai sozinha o dobro de vezes que em dupla.
//  Quer meio a meio? troque por choose(1, 2).
//  Quer sempre sozinha? troque por 1.
// ============================================================
var _quantas = choose(1, 1, 2);

// as duas da leva entram pelo MESMO lado, senão se cruzariam na tela
var _lado = choose(-1, 1);   // +1 = atravessa pra direita, -1 = pra esquerda

var _i      = 0;
var _sx     = 0;
var _sy     = 0;
var _tipo   = noone;
var _sacola = noone;

for (_i = 0; _i < _quantas; _i++) {

    // nasce FORA da tela, no lado de onde o vento vem.
    // a segunda nasce um pouco mais atrás, pra não sobrepor a primeira.
    if (_lado == 1) {
        _sx = _vx - 140 - _i * 160;           // entra pela esquerda
    } else {
        _sx = _vx + _vw + 140 + _i * 160;     // entra pela direita
    }

    // altura: no ar, mas ainda dá pra alcançar pulando
    _sy = _vy + irandom_range(120, _vh - 180);

    // cada sacola da leva pode ser de um tipo diferente
    _tipo = choose(oSacolaPequena, oSacolaGrande);

    _sacola = instance_create_depth(_sx, _sy, -10, _tipo);
    _sacola.dir    = _lado;
    _sacola.y_base = _sy;
}
