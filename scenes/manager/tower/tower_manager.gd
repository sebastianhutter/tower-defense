extends Manager
class_name TowerManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

@export var level_manager: LevelManager
@export var resource_mnanager: ResourceManager

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# @onready var my_label: Label = $%Label

# ========
# class vars
# ========


# ========
# godot functions
# ========

func _ready():
	
	if _game_events:
		# the build manager is responsible to initiate builds and passes
		# the tower resource and the tower position to gameevents. we connect them
		# to the tower manager to spawn in the real tower after the build has completed
		_game_events.tower_build_completed.connect(_on_tower_build_completed)
		_game_events.tower_context_menu_sell_button_clicked.connect(_on_tower_context_menu_sell_button_clicked)
		_game_events.tower_context_menu_upgrade_button_clicked.connect(_on_tower_context_menu_upgrade_button_clicked)


# ========
# signal handler
# ========

func _on_tower_build_completed(resource: TowerResource, tower_position: Vector2) -> void:
	""" game event from build manager - lets place a tower at the given position"""

	print_debug("TowerManager: build completed for tower: " + str(resource.id) + " at position: " + str(tower_position))
	spawn_tower(resource, tower_position)


func _on_tower_destroyed(tower: Tower) -> void:
	""" pass along tower destroyed event to gameevents for other managers and systems to pick up """

	print_debug("TowerManager: tower destroyed: " + str(tower))

	if not _game_events:
		print_debug("TowerManager: could not find game events singleton")
		return

	var tower_resource: TowerResource = tower.get_tower_resource()
	if not tower_resource:
		print_debug("TowerManager: could not find tower resource")
		return

	print_debug("TowerManager: tower destroyed: " + str(tower_resource.id))
	_game_events.tower_destroyed.emit(tower_resource.id, tower.position)

func _on_tower_sold(tower: Tower) -> void:
	""" pass the sold value to gameevents for other managers and systems to pick up """

	print_debug("TowerManager: tower sold: " + str(tower))

	if not _game_events:
		print_debug("TowerManager: could not find game events singleton")
		return

	var tower_level: TowerLevel = tower.get_tower_level_resource()
	if not tower_level:
		print_debug("TowerManager: could not find tower level resource")
		return

	# the different systems need to know th value and the position of the
	# tower that was sold so we only pass the required info, not the whole object
	_game_events.tower_sold.emit(tower_level.sell_value, tower.position)
	

func _on_tower_upgrade_finished(tower: Tower) -> void:

	print_debug("TowerManager: tower upgrade finished: " + str(tower))
	pass

func _on_tower_upgrade_started(tower: Tower) -> void:
	""" pass the upgrade costs to the gamevents for other managers and systems to pick up """

	print_debug("TowerManager: tower upgrade started: " + str(tower))

	if not _game_events:
		print_debug("TowerManager: could not find game events singleton")
		return

	var tower_level: TowerLevel = tower.get_next_tower_level_resource()
	if not tower_level:
		print_debug("TowerManager: could not find tower level resource")
		return
	
	_game_events.tower_upgrade_started.emit(tower_level.build_costs)

func _on_tower_clicked(tower: Tower) -> void:
	""" pass the tower clicked signal with the required infor for the context menu to work """

	if not _game_events:
		print_debug("TowerManager: could not find game events singleton")
		return

	# retrieve all information for the tower context menu
	var tower_upgrade_component: TowerUpgradeComponent = tower.tower_upgrade_component as TowerUpgradeComponent
	var can_be_upgraded: bool = false
	var is_max_level: bool = false
	if tower_upgrade_component:
		is_max_level = tower_upgrade_component.max_level_reached
		can_be_upgraded = not tower_upgrade_component.is_upgrading \
			and not tower_upgrade_component.max_level_reached \
			and tower_upgrade_component.can_be_upgraded \
			and tower_upgrade_component.can_be_afforded
		
	var tower_upgrade_costs: int = 0
	if not is_max_level:
		tower_upgrade_costs = tower.get_next_tower_level_resource().build_costs
	
	var tower_sell_component: TowerSellComponent = tower.tower_sell_component as TowerSellComponent
	var can_be_sold: bool = false
	var tower_sell_value: int = 0
	if tower_sell_component:
		can_be_sold = not tower_sell_component.is_selling and tower_sell_component.can_be_sold
		tower_sell_value = tower.get_tower_level_resource().sell_value

	var tower_speed: float = tower.get_tower_level_resource().shoot_speed
	var tower_damage: float = tower.get_tower_level_resource().shoot_damage
	var tower_range: float = tower.get_tower_level_resource().shoot_range

	print_debug("TowerManager: tower clicked: " + str(tower))
	_game_events.tower_clicked.emit(
		tower.get_instance_id(), 
		tower.tower_resource.name, 
		tower.get_global_transform_with_canvas().origin, 
		can_be_upgraded, 
		is_max_level, 
		can_be_sold, 
		tower_upgrade_costs, 
		tower_sell_value, 
		tower.tower_current_level, 
		tower_speed, 
		tower_damage,
		tower_range,
	)

func _on_tower_context_menu_sell_button_clicked(node_id: int) -> void:
	""" if the sell button is clicked in the tower context manager """
	
	print_debug("TowerManager: tower context menu sell button clicked: " + str(node_id))
	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("TowerManager: could not find level floor instance")
		return

	for tower in floor.towers.get_children():
		if tower.get_instance_id() == node_id:
			var sell_component: TowerSellComponent = tower.tower_sell_component
			if not sell_component:
				print_debug("TowerManager: could not find sell component for tower: " + str(node_id))
				return
			sell_component.sell_tower()	
			return

func _on_tower_context_menu_upgrade_button_clicked(node_id: int) -> void:
	""" if the upgrade button is clicked int he tower context manager """
	print_debug("TowerManager: tower context menu upgrade button clicked: " + str(node_id))

	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("TowerManager: could not find level floor instance")
		return

	for tower in floor.towers.get_children():
		if tower.get_instance_id() == node_id:
			var upgrade_component: TowerUpgradeComponent = tower.tower_upgrade_component
			if not upgrade_component:
				print_debug("TowerManager: could not find upgrade component for tower: " + str(node_id))
				return
			upgrade_component.upgrade_tower()	
			return

func _on_hq_hit(health_left: float) -> void:
	""" pass along hq hit for screen effects """
	_game_events.hq_hit.emit(health_left)

# ========
# class functions
# ========

func _enter_game_loop() -> void:
	var hq: Tower = spawn_tower_by_id(Types.Tower.HQ, Vector2.ZERO+Constants.TOWER_HQ_OFFSET) as HQ
	hq.hq_hit.connect(_on_hq_hit)

func find_tower_resource(id: int) -> TowerResource:
	"""
	finds the tower with the given id
	"""

	for tower in _custom_resource_loader.get_tower_resources():
		if tower.id == id:
			return tower

	return null

					
func spawn_tower_by_id(id: int, pos: Vector2) -> Tower:
	"""
	spawns the tower with the given id at the given position
	"""

	var tower: TowerResource = find_tower_resource(id)
	if not tower:
		print_debug("TowerManager: could not find tower with id: " + str(id))
		return

	var tower_instance: Tower = spawn_tower(tower, pos)
	return tower_instance


func spawn_tower(resource: TowerResource, pos: Vector2) -> Tower:
	"""
	spawns the tower at the given position
	"""
	
	if not level_manager:
		print_debug("TowerManager: could not find level manager")
		return

	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("TowerManager: could not find level floor instance")
		return

	var tower_scene: Tower = resource.tower_scene.instantiate() as Tower
	tower_scene.position = pos
	floor.towers.add_child(tower_scene)
	tower_scene.initialize(resource)
	
	# connect tower signals to manager
	tower_scene.tower_destroyed.connect(_on_tower_destroyed)
	tower_scene.tower_sold.connect(_on_tower_sold)
	tower_scene.tower_upgrade_finished.connect(_on_tower_upgrade_finished)
	tower_scene.tower_upgrade_started.connect(_on_tower_upgrade_started)
	tower_scene.tower_clicked.connect(_on_tower_clicked)
	
	# connect the resource gold changed signal to the towers upgrade manager if available
	var upgrade_component: TowerUpgradeComponent = tower_scene.tower_upgrade_component as TowerUpgradeComponent
	if upgrade_component:
		_game_events.resource_gold_amount_changed.connect(upgrade_component._on_resource_gold_amount_changed)

	return tower_scene