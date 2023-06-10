extends Node
class_name TowerUpgradeComponent

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

@export var construction_component: ConstructionComponent

# ========
# class signals
# ========

signal can_upgrade(can_be_upgraded: bool)
signal tower_upgrade_started()
signal tower_upgrade_finished()

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var can_be_upgraded: bool = false :
	get:
		return can_be_upgraded
	set(value):
		can_be_upgraded = value
		emit_can_upgrade_signal()
var is_upgrading: bool = false :
	get:
		return is_upgrading
	set(value):
		is_upgrading = value
		emit_can_upgrade_signal()

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# connect game event signals
	_game_events.resource_gold_amount_changed.connect(_on_resource_gold_amount_changed)

	# TODO: query the resource manager to check if the tower can be upgraded withoyu waiting for resource change signal

	if construction_component:
		construction_component.hide()
		construction_component.construction_completed.connect(_on_construction_completed)


# ========
# signal handler
# ========

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	""" mark the tower as upgradable if the player has enough gold """

	var next_tower_level = get_parent().get_next_tower_level_resource()
	if not next_tower_level:
		self.can_be_upgraded = false
		return

	if new_amount >= next_tower_level.build_costs:
		self.can_be_upgraded = true
	else:
		self.can_be_upgraded = false

func _on_construction_completed() -> void:
	""" called when the construction is completed """

	tower_upgrade_finished.emit()
	self.is_upgrading = false

# ========
# class functions
# ========

func can_tower_be_upgraded() -> bool:
	""" return if the tower can be upgraded """
	return (not is_upgrading and can_be_upgraded)

func emit_can_upgrade_signal():
	""" if can_be_upgraded or is_upgrading changes emit a signal which can be consumed by other components """
	# the tower can be upgraded if is_upgrading is false 
	# and can be_upgraded is true
	can_upgrade.emit(can_tower_be_upgraded())

func upgrade_tower() -> void:
	""" upgrade the tower """

	if not can_tower_be_upgraded():
		print_debug("TowerUpgradeComponent: cannot upgrade")
		return

	var tower_level: TowerLevel = get_parent().get_next_tower_level_resource()
	if not tower_level:
		print_debug("Tower: no tower level")
		return

	if not construction_component:
		print_debug("Tower: no construction component ")
		return

	self.is_upgrading = true
	tower_upgrade_started.emit()
	construction_component.show()
	construction_component.set_timer(tower_level.build_time)
	construction_component.start_timer()

