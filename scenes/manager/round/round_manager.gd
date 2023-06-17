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

var waves_to_defeat: int = 100 # set impossible win condition until the initial wave signal is received
var waves_defeated: int = 0 :
	get:
		return waves_defeated
	set(value):
		waves_defeated = value
		if waves_defeated >= waves_to_defeat:
			_game_events.game_state_changed.emit(Types.GameState.GAME_OVER, {'did_player_win': true})

# ========
# godot functions
# ========

func _ready():
	if _game_events:
		_game_events.tower_destroyed.connect(_on_tower_destroyed)
		_game_events.wave_incoming.connect(_on_wave_incoming)
		_game_events.wave_defeated.connect(_on_wave_defeated)


# ========
# signal handler
# ========

func _on_tower_destroyed(id: Types.Tower, position: Vector2) -> void:
	""" if the hq tower is destroyed the player looses the round """

	if not _game_events:
		print_debug("RoundManager: _game_events not found")
		return

	if id != Types.Tower.HQ:
		return

	_game_events.game_state_changed.emit(Types.GameState.GAME_OVER, {'did_player_win': false})

func _on_wave_incoming(_time_to_wave: float, _current_wave: int, _next_wave: int, wave_count: int) -> void:
	waves_to_defeat = wave_count

func _on_wave_defeated(_wave_id: int) -> void:
	self.waves_defeated += 1


# ========
# class functions
# ========

