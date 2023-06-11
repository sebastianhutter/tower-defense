extends Node
class_name TowerActionComponent

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

@export var context_menu: TowerContextMenu
@export var tower_upgrade_component: TowerUpgradeComponent
@export var tower_sell_compoonent: TowerSellComponent


# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var is_hovering_over_tower: bool = false

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	if context_menu:
		context_menu.hide()
		context_menu.upgrade_button_pressed.connect(_on_upgrade_button_pressed)
		context_menu.sell_button_pressed.connect(_on_sell_button_pressed)
	if tower_upgrade_component:
		tower_upgrade_component.can_upgrade.connect(_on_can_upgrade)
	if tower_sell_compoonent:
		pass

func _unhandled_input(event):
	if Input.is_action_pressed("Interact"):
		display_context_menu(is_hovering_over_tower)

# ========
# signal handler
# ========

func _on_parent_mouse_entered() -> void:
	is_hovering_over_tower = true

func _on_parent_mouse_exited() -> void:
	is_hovering_over_tower = false

func _on_can_upgrade(can_upgrade: bool) -> void:
	""" if upgrade status changes ensure we update the context menu """

	if context_menu:
		context_menu.enable_upgrade_button(can_upgrade)

# ========
# class functions
# ========

func display_context_menu(is_displayed: bool) -> void:
	""" show or hide the context menu """
	if not context_menu:
		print_debug("TowerActionComponent: no context menu set")
		return

	if is_displayed:
		# always update position and data in context menu before showing it
		context_menu.offset = get_parent().get_global_transform_with_canvas().origin
		update_context_menu()
		context_menu.show()
	else:
		context_menu.hide()


func update_context_menu() -> void:
	""" update the context menu with the current tower data """
	
	var tower_resource: TowerResource = get_parent().get_tower_resource()
	if not tower_resource:
		print_debug("TowerActionComponent: no tower resource set")

	var tower_level: TowerLevel = get_parent().get_tower_level_resource()
	if not tower_resource:
		print_debug("TowerActionComponent: no tower level resource set")

	# if the tower can be sold ensure the sell button is active and shown
	context_menu.enable_sell_button(tower_resource.can_be_sold)
	context_menu.enable_upgrade_button(tower_upgrade_component.can_tower_be_upgraded())

	# set context menu strings
	context_menu.set_tower_name(tower_resource.name)
	context_menu.set_damage(tower_level.damage)
	context_menu.set_speed(tower_level.shoot_speed)
	context_menu.set_upgrade_cost(tower_level.build_costs)
	context_menu.set_sell_value(tower_level.sell_value)

func _on_upgrade_button_pressed() -> void:
	
	if not tower_upgrade_component:
		print_debug("TowerActionComponent: no tower upgrade component set")
		return
	
	tower_upgrade_component.upgrade_tower()
	context_menu.hide()

func _on_sell_button_pressed() -> void:
	""" sell all the things !!! """

	if not tower_sell_compoonent:
		print_debug("TowerActionComponent: no tower sell component set")
		return

	tower_sell_compoonent.sell_tower()
	context_menu.hide()
