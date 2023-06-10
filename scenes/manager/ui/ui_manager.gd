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

# func load_ability_cards() -> void:
# 	"""load the ability cards into the ui"""

# 	ability_ui.load_ability_cards()

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
