extends Node
class_name MenuManager

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData
@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

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
#@onready var ability_select_menu: GameAbilitySelectMenu = $%AbilitySelectMenu
#@onready var level_select_menu: GameLevelSelectMenu = $%LevelSelectMenu

# ========
# class vars
# ========

var menu_stack: Array[Menu] = []

# ========
# godot functions
# ========

func _ready():
	# connect main menu signals
	main_menu.play_button_pressed.connect(_on_main_menu_play_button_pressed)
	main_menu.options_button_pressed.connect(_on_any_options_button_pressed)
	main_menu.quit_button_pressed.connect(_on_main_menu_quit_button_pressed)
	pause_menu.continue_button_pressed.connect(_on_pause_menu_continue_button_pressed)
	pause_menu.options_button_pressed.connect(_on_any_options_button_pressed)
	pause_menu.quit_to_menu_button_pressed.connect(_on_pause_menu_quit_to_menu_button_pressed)
	options_menu.back_button_pressed.connect(_on_any_back_button_pressed)
	#ability_select_menu.level_select_button_pressed.connect(_on_ability_select_menu_level_selected_button_pressed)
	#ability_select_menu.back_button_pressed.connect(_on_any_back_button_pressed)
	#level_select_menu.enter_tower_button_pressed.connect(_on_level_select_menu_enter_tower_button_pressed)
	#level_select_menu.back_button_pressed.connect(_on_any_back_button_pressed)

	hide_menus()


# ========
# signal handler
# ========


func _on_any_back_button_pressed() -> void:
	"""called when the back button is pressed in any menu"""

	# set the game state to playing
	##_game_events.game_state_changed.emit(Types.GameState.LAST_MENU)	

	# go to the last menu in stack
	show_last_menu()


func _on_any_options_button_pressed() -> void:
	"""called when the options button is pressed in any menu"""

	# set the game state to playing

	#_game_events.game_state_changed.emit(Types.GameState.OPTIONS_MENU)
	show_menu(Types.Menu.OPTIONS_MENU)
	

func _on_main_menu_play_button_pressed() -> void:
	"""called when the play button is pressed on the main menu"""

	# set the game state to playing
	#_game_events.game_state_changed.emit(Types.GameState.ABILITY_SELECT_MENU)

	#show_menu(Types.Menu.ABILITY_SELECT_MENU)
	_game_events.game_state_changed.emit(Types.GameState.ENTER_GAME_LOOP)	

# func _on_ability_select_menu_level_selected_button_pressed() -> void:
# 	"""called when the level select button is pressed in the ability select menu"""

# 	# set the game state to playing
# 	#_game_events.game_state_changed.emit(Types.GameState.LEVEL_SELECT_MENU)	

# 	show_menu(Types.Menu.LEVEL_SELECT_MENU)

func _on_main_menu_quit_button_pressed() -> void:
	"""called when the quit button is pressed on the main menu"""

	_game_events.game_state_changed.emit(Types.GameState.QUIT)

func _on_pause_menu_continue_button_pressed() -> void:
	"""called when the continue button is pressed on the pause menu"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.GAME_LOOP)

func _on_pause_menu_quit_to_menu_button_pressed() -> void:
	"""called when the quit to menu button is pressed on the pause menu"""

	# set the game state to playing
	_game_events.game_state_changed.emit(Types.GameState.EXIT_GAME_LOOP)

# func _on_level_select_menu_enter_tower_button_pressed() -> void:
# 	"""called when the enter tower button is pressed in the level select menu"""

# 	# set the game state to playing
# 	_game_events.game_state_changed.emit(Types.GameState.ENTER_GAME_LOOP)	


# ========
# class functions
# ========

func resolve_menu_enum(menu: Types.Menu) -> Menu:
	"""resolves the enum to a menu or null"""

	match menu:
		Types.Menu.MAIN_MENU:
			return main_menu
		Types.Menu.PAUSE_MENU:
			return pause_menu
		Types.Menu.OPTIONS_MENU:
			return options_menu
		# Types.Menu.ABILITY_SELECT_MENU:
		# 	return ability_select_menu
		# Types.Menu.LEVEL_SELECT_MENU:	
		# 	return level_select_menu
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
