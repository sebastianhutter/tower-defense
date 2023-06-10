extends Node
class_name GameStateManager

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

# ========
# export vars
# ========

@export var ui_manager: UiManager
@export var menu_manager: MenuManager
@export var level_manager: LevelManager
@export var tower_manager: TowerManager
@export var resource_manager: ResourceManager
@export var build_manager: BuildManager

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

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():
	_game_events.game_state_changed.connect(_on_game_state_changed)

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
				print("GameStateManager: no menu specified in payload")
				return
			menu_loop(payload["menu"])
		# enter and exit game loop are transient states
		# and shouldnt be stored in the previous state variable
		# so they return immediately
		Types.GameState.ENTER_GAME_LOOP:
			await enter_game_loop()
			return
		Types.GameState.EXIT_GAME_LOOP:
			exit_game_loop()
			return
		Types.GameState.GAME_LOOP:
			game_loop()			
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
	get_tree().quit()

func menu_loop(menu: Types.Menu) -> void:
	"""load the main menu scene"""

	ui_manager.disable_ui()
	get_tree().paused = true
	menu_manager.show_menu(menu)

func enter_game_loop() -> void:
	"""initialiize level manager and handover to game loop"""

	# TODO: maybe add a loading screen here?
	
	# load the level
	# enforce an update signal from the 
	# resource manager to update the resource counters
	# spawn the hq
	# pass the game state to the game loop
	
	level_manager.load_level()
	#tower_manager.spawn_tower_by_id('hq', Vector2.ZERO + Constants.TOWER_BUILD_OFFSET)
	tower_manager.spawn_tower_by_id('hq', Vector2.ZERO)
	resource_manager.increase_gold(0) # fake gold amount change to send signal to everyone who's listening
	get_tree().paused = true
	_game_events.game_state_changed.emit(Types.GameState.GAME_LOOP)

func exit_game_loop() -> void:
	"""unload the level and handover to the main menu"""

	ui_manager.hide_ui()
	menu_manager.hide_menus()
	level_manager.unload_level()
	get_tree().paused = true

	_game_events.game_state_changed.emit(Types.GameState.MENU, {'menu': Types.Menu.MAIN_MENU})

func game_loop() -> void:
	"""load the main loop scene"""

	# if we arrive from the pause menu we need to hide the menus again
	menu_manager.hide_menus()
	ui_manager.show_ui()
	ui_manager.enable_ui()
	build_manager.enable_building()
	resource_manager.start_gold_timer()
	get_tree().paused = false

