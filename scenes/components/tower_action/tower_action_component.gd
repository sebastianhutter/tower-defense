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
var context_menu_is_active: bool = true

var can_be_sold

# ========
# godot functions
# ========

func _ready():
	# enable the context menu only if either an upgrade or a sell component exist
	if tower_upgrade_component:
		has_context_menu = true
		# connect on upgrade_started and finished signal to enable/disable the context menu for the tower
		# this ensures that the context menu does not deliver outdated data while the tower is being upgraded
		tower_upgrade_component.tower_upgrade_started.connect(_on_tower_upgrade_started)
		tower_upgrade_component.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

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

func _on_tower_upgrade_started() -> void:
	context_menu_is_active = false

func _on_tower_upgrade_finished() -> void:
	context_menu_is_active = true

# ========
# class functions
# ========

func display_context_menu() -> void:
	""" show or hide the context menu """

	if not has_context_menu:
		print_debug("TowerActionComponent: no tower sell or upgrade component set")
		return

	if not context_menu_is_active:
		print_debug("TowerActionComponent: context menu is not active")
		return
 

	tower_clicked.emit()

