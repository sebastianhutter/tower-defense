extends Node
class_name TowerUpgradeComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var construction_component: ConstructionComponent

# ========
# class signals
# ========

signal tower_upgrade_started()
signal tower_upgrade_finished()

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var can_be_upgraded: bool = false
var can_be_afforded: bool = false
var max_level_reached: bool = false
var is_upgrading: bool = false

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():

	if construction_component:
		construction_component.hide()
		construction_component.construction_completed.connect(_on_construction_completed)
	

# ========
# signal handler
# ========

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	""" mark the tower as upgradable if the player has enough gold """
	
	check_if_tower_can_upgrade(new_amount)

func _on_construction_completed() -> void:
	""" called when the construction is completed """

	# already check if a future upgrade is possible before emitting
	# the upgrade finished signal. this ensures that the context menu does 
	# not show any wrong upgrade information
	if not get_parent().get_second_next_tower_level_resource():
		self.max_level_reached = true

	tower_upgrade_finished.emit()
	self.is_upgrading = false


# ========
# class functions
# ========

func check_if_tower_can_upgrade(gold: int) -> void:
	""" can the tower be upgraded - e.g. is there a next level and does the player have enough gold """

	var next_tower_level = get_parent().get_next_tower_level_resource()
	if not next_tower_level:
		print_debug("TowerUpgradeComponent: no next tower level")
		self.max_level_reached = true
		return

	if gold >= next_tower_level.build_costs:
		self.can_be_afforded = true
	else:
		self.can_be_afforded = false


func upgrade_tower() -> void:
	""" upgrade the tower """

	if is_upgrading:
		print_debug("TowerUpgradeComponent: already upgrading")
		return

	if max_level_reached:
		print_debug("TowerUpgradeComponent: max level reached")
		return

	if not can_be_upgraded or not can_be_afforded:
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

