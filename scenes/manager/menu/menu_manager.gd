extends Manager
class_name MenuManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

# ========
# export vars
# ========

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var main_menu: GameMainMenu = $%MainMenu
@onready var pause_menu: GamePauseMenu = $%PauseMenu
@onready var options_menu: GameOptionsMenu = $%OptionsMenu
@onready var floor_select_menu: GameFloorSelectMenu = $%FloorSelectMenu
@onready var game_over_win_menu: GameOverWinMenu = $%GameOverWinMenu
@onready var game_over_loose_menu: GameOverLooseMenu = $%GameOverLooseMenu

# ========
# class vars
# ========

var menu_stack: Array[Menu] = []

# ========
# godot functions
# ========

func _ready():
	# connect main menu signals
	if main_menu:
		main_menu.play_button_pressed.connect(_on_main_menu_play_button_pressed)
		main_menu.options_button_pressed.connect(_on_any_options_button_pressed)
		main_menu.quit_button_pressed.connect(_on_main_menu_quit_button_pressed)

	if floor_select_menu:
		floor_select_menu.back_button_pressed.connect(_on_any_back_button_pressed)
		floor_select_menu.start_game_button_pressed.connect(_on_floor_select_menu_start_game_button_pressed)

	if pause_menu:
		pause_menu.continue_button_pressed.connect(_on_pause_menu_continue_button_pressed)
		pause_menu.restart_level_button_pressed.connect(_on_pause_menu_restart_level_button_pressed)
		pause_menu.options_button_pressed.connect(_on_any_options_button_pressed)
		pause_menu.quit_to_menu_button_pressed.connect(_on_pause_menu_quit_to_menu_button_pressed)

	if options_menu:
		options_menu.back_button_pressed.connect(_on_any_back_button_pressed)

	if game_over_win_menu:
		game_over_win_menu.replay_button_pressed.connect(_on_game_over_menu_replay_button_pressed)
		game_over_win_menu.quit_to_menu_button_pressed.connect(_on_game_over_menu_quit_to_menu_button_pressed)

	if game_over_loose_menu:
		game_over_loose_menu.replay_button_pressed.connect(_on_game_over_menu_replay_button_pressed)
		game_over_loose_menu.quit_to_menu_button_pressed.connect(_on_game_over_menu_quit_to_menu_button_pressed)

	hide_menus()


# ========
# signal handler
# ========


func _on_any_back_button_pressed() -> void:
	"""called when the back button is pressed in any menu"""

	# go to the last menu in stack
	show_last_menu()


func _on_any_options_button_pressed() -> void:
	"""called when the options button is pressed in any menu"""

	# set the game state to playing
	show_menu(Types.Menu.OPTIONS_MENU)
	

func _on_main_menu_play_button_pressed() -> void:
	"""called when the play button is pressed on the main menu"""

	show_menu(Types.Menu.FLOOR_SELECT_MENU)

func _on_main_menu_quit_button_pressed() -> void:
	"""called when the quit button is pressed on the main menu"""

	_game_events.game_state_changed.emit(Types.GameState.QUIT)

func _on_pause_menu_continue_button_pressed() -> void:
	"""called when the continue button is pressed on the pause menu"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.GAME_LOOP)


func _on_pause_menu_restart_level_button_pressed() -> void:
	""" called when restart level is pressed """

	_game_events.game_state_changed.emit(Types.GameState.ENTER_GAME_LOOP)

func _on_pause_menu_quit_to_menu_button_pressed() -> void:
	"""called when the quit to menu button is pressed on the pause menu"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.EXIT_GAME_LOOP)

func _on_floor_select_menu_start_game_button_pressed(floor_resource: FloorResource) -> void:
	"""called when the start game button is pressed on the floor select menu """
	
	# store the selected floor globally so we can access the floor resource when hitting replay
	_game_data.selected_floor = floor_resource

	_game_events.game_state_changed.emit(Types.GameState.ENTER_GAME_LOOP)	

func _on_game_over_menu_replay_button_pressed() -> void:
	"""called when the replay button is pressed on the game over screen"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.ENTER_GAME_LOOP)

func _on_game_over_menu_quit_to_menu_button_pressed() -> void:
	"""called when the quit to menu button is pressed on the game over screen"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.EXIT_GAME_LOOP)

# ========
# class functions
# ========


func _menu_loop(menu: Types.Menu) -> void:
	""" handle menu loop events """

	show_menu(menu)

func _game_loop() -> void:
	""" handle game loop events """

	hide_menus()

func _exit_game_loop() -> void:
	hide_menus()

func _game_over() -> void:
	hide_menus()

func resolve_menu_enum(menu: Types.Menu) -> Menu:
	"""resolves the enum to a menu or null"""

	match menu:
		Types.Menu.MAIN_MENU:
			return main_menu
		Types.Menu.PAUSE_MENU:
			return pause_menu
		Types.Menu.OPTIONS_MENU:
			return options_menu
		Types.Menu.FLOOR_SELECT_MENU:
			return floor_select_menu
		Types.Menu.GAME_OVER_WIN_MENU:
			return game_over_win_menu
		Types.Menu.GAME_OVER_LOOSE_MENU:
			return game_over_loose_menu
		_:
			print_debug("MenuManager: menu enum not found")
			return null

func hide_menus() -> void:
	"""hide all game menus"""
	for child in get_children():
		if child is CanvasLayer:
			child.visible = false

	menu_stack.clear()

func show_last_menu() -> void:
	if menu_stack.size() > 1:
		var current_menu: Menu = menu_stack.pop_back()
		var new_menu: Menu = menu_stack.pop_back()
		
		current_menu.hide_menu()
		menu_stack.append(new_menu.show_menu())

func show_menu(menu: Types.Menu) -> void:
	"""show the given menu"""

	# use the enum to define the menu to load 
	# so the game state manager is able to run show_menu too!
	var new_menu = resolve_menu_enum(menu)
	if new_menu == null:
		print_debug("MenuManager: new menu is null")
		return

	if menu_stack.size() > 0:
		var current_menu: Menu = menu_stack[-1]
		if current_menu != null:
			current_menu.hide_menu()

	menu_stack.append(new_menu.show_menu())

func handle_escape_key() -> void:
	"""handle escape key pressed"""

	# if menu stack is > 1 then go back to last menu
	# if in main menu, send quit signal
	# if in pause menu, send continue signal
	# if in level and / game over menus send exit to main menu signal
	if menu_stack.size() > 1:
		show_last_menu()
	else:
		var current_menu: Menu = menu_stack.pop_back()
		if current_menu == null:
			print_debug("MenuManager: current menu is null")
			return
		
		if current_menu == main_menu:
			_game_events.game_state_changed.emit(Types.GameState.QUIT)
		elif current_menu == pause_menu:
			_game_events.game_state_changed.emit(Types.GameState.GAME_LOOP)
