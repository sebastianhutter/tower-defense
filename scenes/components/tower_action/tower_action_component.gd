extends Node
class_name TowerActionComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

#@export var context_menu: TowerContextMenu
@export var tower_upgrade_component: TowerUpgradeComponent
@export var tower_sell_compoonent: TowerSellComponent


# ========
# class signals
# ========

signal tower_clicked()

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var is_hovering_over_tower: bool = false
var has_context_menu: bool = false

var can_be_sold

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	if tower_upgrade_component:
		has_context_menu = true
	if tower_sell_compoonent:
		has_context_menu = true

func _input(event):
	if is_hovering_over_tower:
		if Input.is_action_just_pressed("Interact"): 
			display_context_menu()

# ========
# signal handler
# ========

func _on_parent_mouse_entered() -> void:
	is_hovering_over_tower = true

func _on_parent_mouse_exited() -> void:
	is_hovering_over_tower = false

# ========
# class functions
# ========

func display_context_menu() -> void:
	""" show or hide the context menu """

	if not has_context_menu:
		print_debug("TowerActionComponent: no tower sell or upgrade component set")
		return
 
	tower_clicked.emit()

