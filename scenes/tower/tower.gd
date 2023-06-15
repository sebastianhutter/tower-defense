extends Area2D
class_name Tower

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal tower_destroyed(tower: Tower)
signal tower_sold(tower: Tower)
signal tower_upgrade_finished(tower: Tower)
signal tower_upgrade_started(tower: Tower)
signal tower_clicked(tower: Tower)

# ========
# class onready vars
# ========

@onready var body: Sprite2D = $%Body
@onready var tower_action_component: TowerActionComponent = $%TowerActionComponent
@onready var tower_upgrade_component: TowerUpgradeComponent = $%TowerUpgradeComponent
@onready var tower_sell_component: TowerSellComponent = $%TowerSellComponent

# ========
# class vars
# ========

# store the tower resource and the current level of the tower
var tower_resource: TowerResource = null
var tower_level: TowerLevel = null
var tower_current_level: int = 0


# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():

	# ensure no shader is highlightng the tower
	highligh_tower(false)

	# if the tower supports user actions
	if tower_action_component:
		# enable highlighing of tower by hover
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)

		# pass mouse entered and exited signal to component
		mouse_entered.connect(tower_action_component._on_parent_mouse_entered)
		mouse_exited.connect(tower_action_component._on_parent_mouse_exited)

		# pass click actions to game event system
		tower_action_component.tower_clicked.connect(_on_tower_clicked)

	if tower_upgrade_component:
		tower_upgrade_component.tower_upgrade_started.connect(_on_tower_upgrade_started)
		tower_upgrade_component.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

	if tower_sell_component:
		tower_sell_component.tower_sold.connect(_on_tower_sold)
		
# ========
# signal handler
# ========

func _on_mouse_entered() -> void:
	highligh_tower(true)

func _on_mouse_exited() -> void:
	highligh_tower(false)

func _on_tower_sold() -> void:
	""" tower action component signal handler for selling the tower"""
	sell_tower()

func _on_tower_upgrade_started() -> void:
	""" pass signal along with tower costs """
	start_upgrade_tower()

func _on_tower_upgrade_finished() -> void:
	""" pass signal along with tower costs """
	finish_upgrade_tower()

func _on_tower_clicked() -> void:
	""" if a tower is clicked on """

	print_debug("Tower: tower clicked: " + str(self))
	tower_clicked.emit(self)

# ========
# class functions
# ========

func initialize(resource: TowerResource) -> void:
	""" initialize the tower object """

	tower_resource = resource
	set_tower_level()
	set_upgrade_component()
	set_sell_component()


func set_tower_level() -> void:
	if not tower_resource:
		print_debug("Tower: no tower resource set, cannot set the tower level")
		return

	tower_level = tower_resource.get_level(tower_current_level)

func set_upgrade_component() -> void:
	""" enable or disable the upgrade component """

	if not tower_resource:
		print_debug("Tower: no tower resource set, can not pass can_be_upgraded")
		return

	if not tower_upgrade_component:
		print_debug("Tower: no tower upgrade component set, can not pass can_be_upgraded")
		return

	tower_upgrade_component.can_be_upgraded = tower_resource.can_be_upgraded

func set_sell_component() -> void:
	""" enable or disable the sell component """

	if not tower_resource:
		print_debug("Tower: no tower resource set ,can not pass can_be_upgraded")
		return

	if not tower_sell_component:
		print_debug("Tower: no tower sell component set, can not pass can_be_upgraded ")
		return

	tower_sell_component.can_be_sold = tower_resource.can_be_sold

func get_tower_resource() -> TowerResource:
	return tower_resource

func get_tower_level() -> int:
	return tower_current_level

func get_tower_level_resource() -> TowerLevel:
	""" get the current tower level data """
	return tower_resource.get_level(tower_current_level)

func get_next_tower_level_resource() -> TowerLevel:
	""" helper function to get the nexts level data, required for update menus """
	return tower_resource.get_level(tower_current_level+1)

func get_second_next_tower_level_resource() -> TowerLevel:
	""" helper function to verify upgrade paths """
	return tower_resource.get_level(tower_current_level+2)

func highligh_tower(is_higlighted: bool) -> void:

	if not body or not body.material:
		return

	body.material.set('shader_parameter/enabled', is_higlighted)

func sell_tower() -> void:

	if not tower_level:
		print_debug("Tower: no tower level set, cannot sell the tower")
		return

	tower_sold.emit(self)
	queue_free()

func start_upgrade_tower() -> void:

	var next_level: TowerLevel = get_next_tower_level_resource()
	if not next_level:
		print_debug("Tower: no next tower level set, cannot upgrade the tower")
		return

	tower_upgrade_started.emit(self)

func finish_upgrade_tower() -> void:
	""" finish the upgrade of the tower """

	tower_current_level += 1
	set_tower_level()
	set_tower_body_texture()

	tower_upgrade_finished.emit(self)


func set_tower_body_texture() -> void:
	""" set the body texture of the tower """

	if not body:
		print_debug("Tower: no body set, cannot set the texture")
		return

	if not tower_level:
		print_debug("Tower: no tower level set, cannot set the texture")
		return

	var texture: Texture = tower_level.body
	if not texture:
		print_debug("Tower: no texture set, cannot set the texture")
		return

	body.texture = texture
