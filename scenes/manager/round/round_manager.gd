extends Manager
class_name RoundManager

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

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	_game_events.tower_destroyed.connect(_on_tower_destroyed)


# ========
# signal handler
# ========

func _on_tower_destroyed(id: Types.Tower, position: Vector2):
	""" if the hq tower is destroyed the player looses the round """

	if not _game_events:
		print_debug("RoundManager: _game_events not found")
		return

	if id != Types.Tower.HQ:
		return

	_game_events.game_state_changed.emit(Types.GameState.GAME_OVER, {'did_player_win': false})

# ========
# class functions
# ========

