extends Node
class_name Main

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

# ========
# export vars
# ========

@export var game_state: Types.GameState = Types.GameState.MENU

# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

@onready var game_state_manager: GameStateManager = $%GameStateManager

# ========
# class vars
# ========

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():

	# simple helper for faster debugging, allow switching between default gamestate that is passed
	# if main menu is passed we need to ensure to load the correct menu
	var payload = {}
	if game_state == Types.GameState.MENU:
		payload = {'menu': Types.Menu.MAIN_MENU}

	# when the main node enters ready state emit the game state changed signal
	_game_events.game_state_changed.emit(game_state, payload)

# ========
# signal handler
# ========

# ========
# class functions
# ========

