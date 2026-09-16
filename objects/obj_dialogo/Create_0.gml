nome = "";
textos = [];
portrait = noone;
audios = [];

pagina = 0;
caractere_atual = 0;
velocidade_texto = 0.5;
voz_atual = noone;

// Tempo padrao de espera em segundos caso a fala NAO tenha audio
tempo_padrao_sem_audio = 2.5; 

// Guarda os frames que faltam para pular a pagina atual
tempo_espera_frames = -1;