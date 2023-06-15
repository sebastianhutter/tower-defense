extends Node
class_name GameStateManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

# ========
# export vars
# ========

@export var ui_manager: UiManager
@export var menu_manager: MenuManager
@export var level_manager: LevelManager
@export var tower_manager: TowerManager
@export var resource_manager: ResourceManager
@export var build_manager: BuildManager
@export var enemy_manager: EnemyManager
@export var round_manager: RoundManager

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var previous_state: Types.GameState = Types.GameState.NONE
var current_state: Types.GameState = Types.GameState.NONE

var registered_managers: Array[Manager] = []

# ========
# godot functions
# ========

func _ready():
	_game_events.game_state_changed.connect(_on_game_state_changed)

	# collect all managers in a sorted array to easily iterate over the
	# game state functions of each manager
	if level_manager:
		registered_managers.append(level_manager)
	if resource_manager: 
		registered_managers.append(resource_manager)
	if ui_manager:
		registered_managers.append(ui_manager)
	if menu_manager:
		registered_managers.append(menu_manager)
	if tower_manager:
		registered_managers.append(tower_manager)
	if build_manager:
		registered_managers.append(build_manager)
	if enemy_manager:
		registered_managers.append(enemy_manager)
	if round_manager:
		registered_managers.append(round_manager)
	
	print(registered_managers)

func _unhandled_input(event):
	"""
	Handles input events that are handled by any other node
	"""

	if event is InputEventKey:
		# handle escape key presses
		if event.pressed and event.keycode == KEY_ESCAPE:
			if current_state == Types.GameState.GAME_LOOP:
				_game_events.game_state_changed.emit(Types.GameState.MENU, {"menu": Types.Menu.PAUSE_MENU})
			elif current_state == Types.GameState.MENU:
				# if escape is pressed whilest in a menu handling escape is passed along to the menu manager
				menu_manager.handle_escape_key()

			
# ========
# signal handler
# ========

func _on_game_state_changed(game_state: Types.GameState, payload: Dictionary = {}) -> void:

	print_debug("GameStateManager: game state changed to " + str(game_state))
	
	match game_state:
		Types.GameState.NONE:
			# this should never happen
			return
		Types.GameState.MENU:
			if payload.has("menu") == false:
				print_debug("GameStateManager: no menu specified in payload")
				return
			menu_loop(payload["menu"])
		# enter and exit game loop are transient states
		# and shouldnt be stored in the previous state variable
		# so they return immediately
		Types.GameState.ENTER_GAME_LOOP:
			if not  _game_data.selected_floor:
				print_debug("GameStateManager: no floor selected")
				return

			enter_game_loop()
			return
		Types.GameState.EXIT_GAME_LOOP:
			exit_game_loop()
			return
		Types.GameState.GAME_LOOP:
			game_loop()		
		Types.GameState.GAME_OVER:
			if payload.has("did_player_win") == false:
				print_debug("GameStateManager: no did_player_win specified in payload")
				return

			game_over(payload["did_player_win"])
		Types.GameState.QUIT:
			quit_game()

	previous_state = current_state	
	current_state = game_state

# ========
# class functions
# ========
	
func quit_game() -> void:
	"""quit the game"""

	# the only valid execution is from the main menu
	# there is no way to quit from the game loop
	print_debug("GameStateManager: quitting game")

	for manager in registered_managers:
		if manager.has_method("_quit"):
			manager._quit()

	get_tree().quit()

func menu_loop(menu: Types.Menu) -> void:
	"""load the main menu scene"""

	get_tree().paused = true
	for manager in registered_managers:
		if manager.has_method("_menu_loop"):
			manager._menu_loop(menu)

func enter_game_loop() -> void:
	"""initialiize level manager and handover to game loop"""

	get_tree().paused = true
	for manager in registered_managers:
		if manager.has_method("_enter_game_loop"):
			manager._enter_game_loop()

	_game_events.game_state_changed.emit(Types.GameState.GAME_LOOP)


func game_loop() -> void:
	"""load the main loop scene"""

	for manager in registered_managers:
		if manager.has_method("_game_loop"):
			print("GameStateManager: calling game loop on " + str(manager))
			manager._game_loop()

	get_tree().paused = false


func exit_game_loop() -> void:
	"""unload the level and handover to the main menu"""

	get_tree().paused = true
	for manager in registered_managers:
		if manager.has_method("_exit_game_loop"):
			manager._exit_game_loop()


	_game_events.game_state_changed.emit(Types.GameState.MENU, {'menu': Types.Menu.MAIN_MENU})

func game_over(did_player_win: bool) -> void:
	""" display the game over screen """

	get_tree().paused = true
	for manager in registered_managers:
		if manager.has_method("_game_over"):
			manager._game_over()


	if did_player_win:
		menu_manager.show_menu(Types.Menu.GAME_OVER_WIN_MENU)
	else:
		menu_manager.show_menu(Types.Menu.GAME_OVER_LOOSE_MENU)
