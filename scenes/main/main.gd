extends Node
class_name Main

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

# ========
# class signals
# ========

# signal my_custom_signal

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
	
	# when the main node enters ready state emit the game state changed signal
	_game_events.game_state_changed.emit(Types.GameState.MENU, {'menu': Types.Menu.MAIN_MENU})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_custom_signal_event():
	pass

# ========
# class functions
# ========

