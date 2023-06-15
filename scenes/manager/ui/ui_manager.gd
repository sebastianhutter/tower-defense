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

	if _game_events:
		# pass the resource changed event to the hud
		_game_events.resource_gold_amount_changed.connect(hud._on_resource_gold_amount_changed)
		_game_events.tower_clicked.connect(hud._on_tower_clicked)

	if hud:
		hud.tower_card_clicked.connect(_on_tower_card_clicked)
		# connect button events from the context manager to the game events singleton
		# so they can be consumed by the tower manager
		hud.tower_context_menu_upgrade_button_clicked.connect(_on_tower_context_menu_upgrade_button_clicked)
		hud.tower_context_menu_sell_button_clicked.connect(_on_tower_context_menu_sell_button_clicked)



# ========
# signal handler
# ========

func _on_tower_card_clicked(tower_resource: Resource) -> void:
	""" pass the tower card clcked event along to the gameevents singleton """

	_game_events.tower_card_clicked.emit(tower_resource)

func _on_tower_context_menu_upgrade_button_clicked(node_id: int) -> void:
	""" pass the tower context menu upgrade button clicked event along to the gameevents singleton """

	_game_events.tower_context_menu_upgrade_button_clicked.emit(node_id)

func _on_tower_context_menu_sell_button_clicked(node_id: int) -> void:
	""" pass the tower context menu sell button clicked event along to the gameevents singleton """

	_game_events.tower_context_menu_sell_button_clicked.emit(node_id)

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

func _game_over() -> void:
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
