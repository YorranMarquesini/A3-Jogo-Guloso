// Calcula quanto cada item reduz, baseado no total daquela fase
var _total_trash = instance_number(oTrashCollectible);

global.pollution_total = _total_trash;
global.pollution_pct = 100; // sempre começa cheia na fase

if (_total_trash > 0) {
    global.pollution_reduction_per_item = 100 / _total_trash;
} else {
    global.pollution_reduction_per_item = 0;
}