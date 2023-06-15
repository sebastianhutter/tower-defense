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

func _on_tower_clicked(tower: Tower, can_be_upgraded: bool, can_be_sold: bool) -> void:
	""" pass the tower clicked signal with the required infor for the context menu to work """

	if not _game_events:
		print_debug("TowerManager: could not find game events singleton")
		return

	var node_id: int = tower.get_instance_id()
	
	var tower_sell_value: int = 0
	if can_be_sold:
		var current_tower_level: TowerLevel = tower.get_tower_level_resource()
		if current_tower_level:
			tower_sell_value = current_tower_level.sell_value
		
	var tower_upgrade_costs: int = 0
	if can_be_upgraded:
		var next_tower_level: TowerLevel = tower.get_next_tower_level_resource()	
		if next_tower_level:
			tower_upgrade_costs = next_tower_level.build_costs


	var tower_type: String = tower.tower_resource.name
	var tower_canvas_position: Vector2 = tower.get_global_transform_with_canvas().origin
	

	print_debug("TowerManager: tower clicked: " + str(tower_type))
	_game_events.tower_clicked.emit(node_id, tower_type, tower_canvas_position, can_be_upgraded, can_be_sold, tower_upgrade_costs, tower_sell_value)

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



# ========
# class functions
# ========

func _enter_game_loop() -> void:
	spawn_tower_by_id(Types.Tower.HQ, Vector2.ZERO+Constants.TOWER_HQ_OFFSET)

func find_tower_resource(id: int) -> TowerResource:
	"""
	finds the tower with the given id
	"""

	for tower in _custom_resource_loader.get_tower_resources():
		if tower.id == id:
			return tower

	return null

					
func spawn_tower_by_id(id: int, pos: Vector2) -> void:
	"""
	spawns the tower with the given id at the given position
	"""

	var tower: TowerResource = find_tower_resource(id)
	if not tower:
		print_debug("TowerManager: could not find tower with id: " + str(id))
		return

	spawn_tower(tower, pos)
	

func spawn_tower(resource: TowerResource, pos: Vector2) -> void:
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
	tower_scene.initialize(resource)
	tower_scene.position = pos
	floor.towers.add_child(tower_scene)

	# connect tower signals to manager
	tower_scene.tower_destroyed.connect(_on_tower_destroyed)
	tower_scene.tower_sold.connect(_on_tower_sold)
	tower_scene.tower_upgrade_finished.connect(_on_tower_upgrade_finished)
	tower_scene.tower_upgrade_started.connect(_on_tower_upgrade_started)
	tower_scene.tower_clicked.connect(_on_tower_clicked)
