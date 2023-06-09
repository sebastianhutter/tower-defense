extends Node
class_name ResourceManager

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData
@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

@export var gold_increase_time: float = 5.0
@export var gold_increase_amount: int = 100
@export var gold_amount: int = 1000

# ========
# class signals
# ========

signal resource_gold_amount_changed(old_amount: int, new_amount: int)

# ========
# class onready vars
# ========

@onready var gold_timer: Timer = $%GoldTimer

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if _game_events:
		resource_gold_amount_changed.connect(_game_events._on_resource_gold_amount_changed)
		_game_events.tower_build_started.connect(_on_tower_build_started)
		_game_events.tower_sold.connect(_on_tower_sold)
		
	if gold_timer:
		gold_timer.timeout.connect(_on_gold_timer_timeout)
		gold_timer.wait_time = gold_increase_time


# ========
# signal handler
# ========

func _on_gold_timer_timeout():
	""" increase the gold resource by amount """

	print_debug("_on_gold_timer_timeout")
	increase_gold(gold_increase_amount)

func _on_tower_build_started(resource: TowerResource, position: Vector2):
	""" decrease the gold resource by amount """

	decrease_gold(resource.get_level(0).build_costs)

func _on_tower_sold(sell_value: int, pos: Vector2) -> void:
	""" increase the gold resource by amount """

	increase_gold(sell_value)

# ========
# class functions
# ========

func start_gold_timer():
	""" start the gold timer """

	if not gold_timer:
		print_debug("gold_timer is not set")
		return

	gold_timer.start()
	

func increase_gold(amount: int):
	set_gold_amount(gold_amount + amount)

func decrease_gold(amount: int):
	set_gold_amount(gold_amount - amount)

func set_gold_amount(new_amount: int):

	var old_amount = gold_amount
	gold_amount = new_amount
	resource_gold_amount_changed.emit(old_amount, new_amount)
	
func get_gold_amount() -> int:
	return gold_amount
