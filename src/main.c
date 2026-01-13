#include <gb/gb.h> // Inclure les définitions de la Game Boy
#include "../res/player.h" // Inclure les données du sprite du joueur

#define PLAYER_TILE_INDEX 0 // Index de la première tuile du joueur
#define NUM_PLAYER_TILES 1 // Nombre de tuiles utilisées par le joueur

// Stocke les positions (x, y) du joueur
UBYTE player_x = 80;
UBYTE player_y = 72;

// Procédure pour initialiser les graphismes
void setup_graphics(void) {
    // Charger les données du sprite du joueur
    // PLAYER_TILE_INDEX est l'index de la première tuile (0 ici)
    // NUM_PLAYER_TILES est le nombre de tuiles utilisées par le joueur
    set_sprite_data(PLAYER_TILE_INDEX, NUM_PLAYER_TILES, SPR_PLAYER);
    set_sprite_tile(0, PLAYER_TILE_INDEX);
    // Initialiser la position du sprite du joueur
    move_sprite(0, player_x, player_y);

    SHOW_SPRITES; // Activer l'affichage des sprites
    DISPLAY_ON; // Allumer l'écran
}

// Procédure d'entrée
void main(void) {
    setup_graphics(); // Initialiser les graphismes

    // Boucle de jeu principale
    while(1) {
        UBYTE keys = joypad(); // Lire l'état des boutons
        UBYTE moved = FALSE; // Savoir si le joueur a bougé

        // Mettre à jour la position du joueur en fonction des entrées
        // Si le joueur appuie sur la gauche et n'est pas au bord gauche
        if (keys &J_LEFT && player_x > 8) {
            player_x -= 1; // Déplacer vers la gauche
            moved = TRUE; // Indiquer que le joueur a bougé
        // Sinon, si le joueur appuie sur la droite et n'est pas au bord droit
        } else if (keys &J_RIGHT && player_x < SCREENWIDTH) {
            player_x += 1; // Déplacer vers la droite
            moved = TRUE;
        }

        // Si le joueur appuie sur le haut et n'est pas au bord supérieur
        if (keys &J_UP && player_y > 16) {
            player_y -= 1; // Déplacer vers le haut
            moved = TRUE;
        // Sinon, si le joueur appuie sur le bas et n'est pas au bord inférieur
        } else if (keys &J_DOWN && player_y < SCREENHEIGHT + 8) {
            player_y += 1; // Déplacer vers le bas
            moved = TRUE;
        }

        // Si le joueur a bougé, mettre à jour la position du sprite
        if (moved) {
            move_sprite(0, player_x, player_y); // Mettre à jour la position du sprite du joueur
        }

        vsync();
    }
}