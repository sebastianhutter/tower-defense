class_name Types

# possible game states for game state manager
enum GameState {
	NONE = -1,
	MENU,
	ENTER_GAME_LOOP,
	GAME_LOOP,
	GAME_OVER,
	EXIT_GAME_LOOP,
	QUIT,
}

enum Menu {
	MAIN_MENU = 0,
	FLOOR_SELECT_MENU,
	OPTIONS_MENU,
	PAUSE_MENU,
	GAME_OVER_WIN_MENU,
	GAME_OVER_LOOSE_MENU,
}

# tower types for easier configuration
enum Tower {
	HQ = 0,
	ARCHER,
	WIZARD,
}

# floor ids for easier configuration
enum Floor {
	GRASS = 0,
	WINTER,
	DESERT,
}

# tile id origins
# the full tile id is calculated by adding the 
# the biome offset (specified in the floor)
enum TileOrigin {
	SPAWNER = 90,
	CONSTRUCTION = 100,
	FLOOR = 110,
	FOUNDATION = 120,
}