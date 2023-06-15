extends Manager
class_name ResourceManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

# ========
# export vars
# ========

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var gold_timer: Timer = $%GoldTimer

# ========
# class vars
# ========

var gold_amount: int = 0 

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if _game_events:
		_game_events.tower_build_started.connect(_on_tower_build_started)
		_game_events.tower_sold.connect(_on_tower_sold)
		_game_events.tower_upgrade_started.connect(_on_tower_upgrade_started)
		
	if gold_timer:
		gold_timer.timeout.connect(_on_gold_timer_timeout)

# ========
# signal handler
# ========

func _on_gold_timer_timeout():
	""" increase the gold resource by amount """

	print_debug("_on_gold_timer_timeout")
	increase_gold(_game_data.selected_floor.gold_auto_increase_amount)

func _on_tower_build_started(resource: TowerResource, position: Vector2):
	""" decrease the gold resource by amount """

	decrease_gold(resource.get_level(0).build_costs)

func _on_tower_sold(sell_value: int, pos: Vector2) -> void:
	""" increase the gold resource by amount """

	increase_gold(sell_value)

func _on_tower_upgrade_started(build_costs: int) -> void:
	""" decrease the gold resource by amount """

	decrease_gold(build_costs)	

# ========
# class functions
# ========

func _enter_game_loop() -> void:
	""" start the game loop """

	load_floor()

func _game_loop() -> void:
	# emit fake gold resource change signal to ensure all uis are updated

	increase_gold(0)
	start_gold_timer()

func _exit_game_loop() -> void:
	stop_gold_timer()

func _game_over() -> void:
	stop_gold_timer()


func load_floor():
	""" configure the resource manager with the given floor resource """

	if _game_data.selected_floor.gold_starting_amount:
		set_gold_amount(_game_data.selected_floor.gold_starting_amount)

	if _game_data.selected_floor.gold_auto_increase_time:
		gold_timer.wait_time = _game_data.selected_floor.gold_auto_increase_time
		
func start_gold_timer():
	""" start the gold timer """

	if not gold_timer:
		print_debug("gold_timer is not set")
		return

	if not _game_data.selected_floor.gold_auto_increase_enabled:
		print_debug("gold_auto_increase_enabled is not set")
		return

	if not gold_timer.is_stopped():
		print_debug("WaveUi: timer already running")
		return 

	gold_timer.start()
	

func stop_gold_timer():
	""" stop the gold timer """

	if not gold_timer:
		print_debug("gold_timer is not set")
		return

	gold_timer.stop()

func increase_gold(amount: int):
	set_gold_amount(gold_amount + amount)

func decrease_gold(amount: int):
	set_gold_amount(gold_amount - amount)

func set_gold_amount(new_amount: int):

	var old_amount = gold_amount
	gold_amount = new_amount
	_game_events.resource_gold_amount_changed.emit(old_amount, new_amount)
	
func get_gold_amount() -> int:
	return gold_amount
