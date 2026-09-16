// --- TEXTO DOS CRÉDITOS ---
// Use \n para quebrar linhas e dar espaçamento entre cargos/nomes
texto_creditos = 
    "[ NOME DO SEU JOGO ]\n\n\n" +
    "PROGRAMACAO\n" +
    "Tiago\n" +
    "Yorran\n" +
    "Joao Pedro\n\n\n" +
    "ARTE\n" +
    "Joao Pedro\n" +
    "Rayane\n\n\n" +
    "DUBLAGEM\n" +
    "Arthur\n\n\n\n\n" +
    "Pressione ESC, ENTER ou CLIQUE para voltar ao Menu";

// --- POSICIONAMENTO DA ROLAGEM ---
// Inicia o texto logo abaixo do limite inferior do monitor
pos_y = display_get_gui_height() + 50; 

// Velocidade com que o texto sobe (ajuste se quiser mais rápido ou devagar)
velocidade = 1.5;