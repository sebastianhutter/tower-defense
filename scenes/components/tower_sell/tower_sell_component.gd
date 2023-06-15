extends Node
class_name TowerSellComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal tower_sold

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var can_be_sold: bool = true

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_custom_signal_event():
	pass

# ========
# class functions
# ========

func can_tower_be_sold() -> bool:
	""" check if tower can be sold """

	var tower_resource: TowerResource = get_parent().get_tower_resource()
	if not tower_resource:
		print_debug("TowerSellComponent: no tower resource")
		return false
	
	return tower_resource.can_be_sold

func sell_tower():
	""" sell the tower if tower can be sold """

	if not can_tower_be_sold():
		print_debug("TowerSellComponent: tower can't be sold")
		return

	tower_sold.emit()

	