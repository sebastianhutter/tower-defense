extends Area2D
class_name Tower

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

# ========
# class signals
# ========

signal tower_sold(sell_value: int, position: Vector2)
signal tower_upgrade_started()
signal tower_upgrade_finished()

# ========
# class onready vars
# ========

@onready var context_menu_scene = preload(Constants.SCENE_TOWER_CONTEXT_MENU)
@onready var body: Sprite2D = $%Body

# ========
# class vars
# ========

var tower_resource: TowerResource = null
var tower_level: TowerLevel = null


var is_hovering_over_tower: bool = false
var tower_context_menu: TowerContextMenu = null


# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	highligh_tower(is_hovering_over_tower)


	# instance the context menu for the tower in the background
	# this allows feeding info into it but simply not displaying it.
	# makes the logic easier, but not as clean, the neat thing would be to
	# push the handling of the context ui to the ui manager, but that
	# makes it more complicated (e.g. what happens when the ui is open and the tower gets destroyed etc.)
	tower_context_menu = context_menu_scene.instantiate() as TowerContextMenu
	tower_context_menu.hide()
	add_child(tower_context_menu)

	tower_context_menu.upgrade_button_pressed.connect(_on_upgrade_button_pressed)
	tower_context_menu.sell_button_pressed.connect(_on_sell_button_pressed)

	# ensure we check the current gold resource amount to see if we can upgrade the tower or not
	_game_events.resource_gold_amount_changed.connect(_on_resource_gold_amount_changed)
	
	tower_sold.connect(_game_events._on_tower_sold)

func _unhandled_input(event):
	if Input.is_action_pressed("Interact"):
		display_context_menu(is_hovering_over_tower)


# ========
# signal handler
# ========

func _on_mouse_entered() -> void:
	is_hovering_over_tower = true
	highligh_tower(is_hovering_over_tower)

func _on_mouse_exited() -> void:
	is_hovering_over_tower = false
	highligh_tower(is_hovering_over_tower)

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:

	if not tower_level:
		print_debug("Tower: no tower level set, cannot check if we can upgrade the tower")

	
	if new_amount >= tower_level.build_costs:
		tower_context_menu.activate_upgrade_button(true)
	else:
		tower_context_menu.activate_upgrade_button(false)

func _on_upgrade_button_pressed() -> void:
	pass

func _on_sell_button_pressed() -> void:

	if not tower_level:
		print_debug("Tower: no tower level set, cannot sell the tower")
		return

	tower_sold.emit(tower_level.sell_value, position)
	queue_free()


# ========
# class functions
# ========

func set_tower_resource(resource: TowerResource, level_number: int = 0) -> void:
	""" set the tower resource and apply the data to the tower """

	tower_resource = resource
	tower_level = tower_resource.get_level(level_number)

func highligh_tower(is_higlighted: bool) -> void:

	if not body or not body.material:
		return

	body.material.set('shader_parameter/enabled', is_higlighted)

func display_context_menu(is_displayed: bool) -> void:
	if is_displayed:
		tower_context_menu.offset = get_global_transform_with_canvas().origin
		update_context_menu()
		tower_context_menu.show()
	else:
		tower_context_menu.hide()

func update_context_menu() -> void:
	""" update the context menu with the current tower data """
	
	if not tower_level:
		print_debug("Tower: no tower level set, cannot update the context menu")
		return

	# if the tower can be sold ensure the sell button is active and shown
	if tower_resource.can_be_sold:
		tower_context_menu.enable_sell_button(true)
	else:
		tower_context_menu.enable_sell_button(false)


	tower_context_menu.set_tower_name('name')
	tower_context_menu.set_damage(tower_level.damage)
	tower_context_menu.set_speed(tower_level.shoot_speed)
	tower_context_menu.set_upgrade_cost(tower_level.build_costs)
	tower_context_menu.set_sell_value(tower_level.sell_value)
