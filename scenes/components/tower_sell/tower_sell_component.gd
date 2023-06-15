extends Node
class_name TowerSellComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

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

var is_selling: bool = false
var can_be_sold: bool = false

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func sell_tower():
	""" sell the tower if tower can be sold """

	if is_selling:
		print_debug("TowerSellComponent: tower is already selling")
		return

	if not can_be_sold:
		print_debug("TowerSellComponent: tower cannot be sold")
		return
		
	is_selling = true
	tower_sold.emit()

	