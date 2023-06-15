extends Manager
class_name UiManager

# ========
# singleton references
# ========

@onready var _game_data = get_node("/root/GameDataSingleton") as GameData
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

@onready var hud: HUD = $%HUD

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:
	# hide the ui while starting up
	hide_ui()
	disable_ui()

	# pass the resource changed event to the hud
	_game_events.resource_gold_amount_changed.connect(hud._on_resource_gold_amount_changed)
	# pass tower card clicked to the game events
	hud.tower_card_clicked.connect(_game_events._on_tower_card_clicked)

# ========
# signal handler
# ========

# ========
# class functions
# ========

func _menu_loop(menu: Types.Menu) -> void:
	""" when the menuy is active the ui elements need to be disabled """
	disable_ui()
	
func _enter_game_loop() -> void:
	load_floor()
	hud.load_tower_cards()
	

func _game_loop() -> void:
	""" when the game is active the ui elements need to be enabled """
	enable_ui()
	show_ui()

	# TODO: connect to signal from enemy/wave manager
	start_wave_progress_bar()

func _exit_game_loop() -> void:
	hide_ui()
	disable_ui()

func load_floor() -> void:
	"""load the given floor information into the UI """


	# setup the initial progress bar timer for the wave
	hud.wave_ui.set_timer(_game_data.selected_floor.wave_initial_delay)
	hud.wave_ui.set_wave_counter(0, _game_data.selected_floor.wave_count)


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
