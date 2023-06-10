class_name Types

# possible game states for game state manager
enum GameState {
	NONE = -1,
	MENU,
	ENTER_GAME_LOOP,
	GAME_LOOP,
	GAME_OVER,
	LEVEL_END,
	EXIT_GAME_LOOP,
	QUIT,
}

enum Menu {
	MAIN_MENU,
	OPTIONS_MENU,
	PAUSE_MENU,
	LEVEL_END_MENU,
	GAME_OVER_MENU,
}
