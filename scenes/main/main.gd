extends Node
class_name Main

# ========
# singleton references
# ========


@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var game_state: Types.GameState = Types.GameState.MENU

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():

	# get game_state manager from managers inherited scene
	

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

