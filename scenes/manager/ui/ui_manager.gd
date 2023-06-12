extends Node
class_name UiManager

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

@onready var hud: HUD = $%HUD

# ========
# class vars
# ========

var floor_resource: FloorResource = null

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	# hide the ui while starting up
	hide_ui()
	disable_ui()

# ========
# signal handler
# ========

# ========
# class functions
# ========

func load_floor(floor_resource: FloorResource) -> void:
	"""load the given floor information into the UI """

	self.floor_resource = floor_resource

	# setup the initial progress bar timer for the wave
	hud.wave_ui.set_timer(floor_resource.wave_initial_delay)
	hud.wave_ui.set_wave_counter(0, floor_resource.wave_count)


func start_wave_progress_bar() -> void:

	hud.wave_ui.start_timer()

func hide_ui() -> void:
	"""hide all game ui elements"""

	if not hud:
		return

	hud.hide_all_uis()

func show_ui() -> void:
	"""show all game ui elements"""

	if not hud:
		return

	hud.show_all_uis()

func disable_ui() -> void:
	""" disables mouse handling for the ui chiildren """
	
	hud.process_mode = Node.PROCESS_MODE_DISABLED

func enable_ui() -> void:
	""" enables mouse handling for the ui chiildren """
	
	hud.process_mode = Node.PROCESS_MODE_INHERIT
