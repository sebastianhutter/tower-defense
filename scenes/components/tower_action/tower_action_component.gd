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

signal tower_clicked(can_be_upgraded: bool, can_be_sold: bool)

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var is_hovering_over_tower: bool = false
var has_context_menu: bool = false

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	# if context_menu:
	# 	context_menu.hide()
	# 	context_menu.upgrade_button_pressed.connect(_on_upgrade_button_pressed)
	# 	context_menu.sell_button_pressed.connect(_on_sell_button_pressed)
	if tower_upgrade_component:
		tower_upgrade_component.can_upgrade.connect(_on_can_upgrade)
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

func _on_can_upgrade(can_upgrade: bool) -> void:
	""" if upgrade status changes ensure we update the context menu """
	pass
	# if context_menu:
	# 	context_menu.enable_upgrade_button(can_upgrade)

# ========
# class functions
# ========

func display_context_menu() -> void:
	""" show or hide the context menu """

	if not has_context_menu:
		print_debug("TowerActionComponent: no tower sell or upgrade component set")
		return

	var can_be_upgraded: bool = false
	if tower_upgrade_component:
		can_be_upgraded = tower_upgrade_component.can_tower_be_upgraded()
	var can_be_sold: bool = false
	if tower_sell_compoonent:
		can_be_sold = tower_sell_compoonent.can_tower_be_sold()

	tower_clicked.emit(can_be_upgraded, can_be_sold)

