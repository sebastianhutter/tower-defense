extends Manager
class_name BuildManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var build_offset: Vector2 = Constants.TOWER_BUILD_OFFSET
@export var level_manager: LevelManager
@export var resource_manager: ResourceManager

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var center: Node2D = $%Center

# ========
# class vars
# ========

var is_building_enabled: bool = false
var is_building: bool = false
# build preview scene following the players mouse cursor
var tower_build_resource: TowerResource = null
var tower_build_preview: PackedScene = preload(Constants.SCENE_TOWER_BUILD_PREVIEW)
var tower_build_preview_instance: TowerBuildPreview = null
# construction site scene placed on top of the construction site tile
var tower_build_construction_site: PackedScene = preload(Constants.SCENE_TOWER_BUILD_CONSTRUCTION_SITE)


# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# ensure building is disabled while everything is initializing
	disable_building()

	# connect to game events
	_game_events.tower_card_clicked.connect(_on_tower_card_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_building == true and tower_build_preview_instance:
		check_build_process()

func _unhandled_input(event):
	""" handle build interactions - unhandled input is used to allow the gui input to be handled first else we may place towers immediately when clicking a tower card!"""
	
	if is_building == true:
		if Input.is_action_pressed("Interact"):
			build_tower()
		if Input.is_action_pressed("Cancel"):
			cancel_build_process()
	

# ========
# signal handler
# ========

func _on_tower_card_clicked(resource: TowerResource) -> void:
	"""enter building mode for the given tower resource"""

	if is_building_enabled == false:
		print_debug("building is disabled")
		return

	start_build_process(resource)

func _on_consutrction_site_build_completed(resource: TowerResource, pos: Vector2) -> void:
	"""handle the construction site build completed signal"""

	# send tower build signal 
	_game_events.tower_build_completed.emit(resource, pos)

# ========
# class functions
# ========

func _enter_game_loop() -> void:
	""" ensure building is disabled and all possible building scenes are unloaded """
	
	# disable building
	disable_building()


func _game_loop() -> void:
	"""handle the game loop started signal"""

	# enable building
	enable_building()

func _game_over() -> void:
	# disable building
	disable_building()

	tower_build_resource = null


func disable_building() -> void:
	is_building_enabled = false

func enable_building() -> void:
	is_building_enabled = true

func start_build_process(resource: TowerResource) -> void:
	"""start the building process"""

	if not level_manager:
		print_debug("BuildManager: could not find level manager")
		return

	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("TowerManager: could not find level floor instance")
		return
	
	if is_instance_valid(tower_build_preview_instance):
		tower_build_preview_instance.queue_free()

	


	is_building = true
	tower_build_resource = resource

	tower_build_preview_instance = tower_build_preview.instantiate() as TowerBuildPreview
	floor.towers.add_child(tower_build_preview_instance)
	tower_build_preview_instance.set_preview_image(resource.build_icon)

	var tower_level_resource = resource.get_level(0)
	if tower_level_resource:
		tower_build_preview_instance.set_range_preview(tower_level_resource.shoot_range)


func cancel_build_process() -> void:
	"""cancel the building process"""

	if not tower_build_preview_instance:
		print_debug("no tower build preview instance found")
		return

	tower_build_preview_instance.queue_free()
	tower_build_resource = null
	is_building = false

func place_construction_site(pos: Vector2) -> void:
	""" places a construction site node with timer to build the tower"""

	if not tower_build_preview_instance:
		print_debug("no tower build preview instance found")
		return

	if not level_manager:
		print_debug("BuildManager: could not find level manager")
		return

	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("TowerManager: could not find level floor instance")
		return

	# place construction site placeholder on top of the tile
	var construction_site_instance  = tower_build_construction_site.instantiate()
	if not construction_site_instance:
		print_debug("no construction site instance found")
		return

	floor.towers.add_child(construction_site_instance)
	construction_site_instance.tower_build_completed.connect(_on_consutrction_site_build_completed)
	construction_site_instance.resource = tower_build_resource
	construction_site_instance.set_position(pos)
	construction_site_instance.start_construction()


func build_tower() -> void:
	"""build the tower"""

	if not tower_build_preview_instance:
		print_debug("no tower build preview instance found")
		return

	if not tower_build_preview_instance.is_buildable:
		return

	var build_position: Vector2 = get_build_position()
	# send tower build signal 
	_game_events.tower_build_started.emit(tower_build_resource, build_position)
	
	# set construction site placeholder
	place_construction_site(build_position)

	# and cancel the build process
	cancel_build_process()


func get_build_position() -> Vector2:
	"""
	returns the towers build position
	"""

	# setup reference to level manager to snap to grid
	if not level_manager:
		print_debug("no level manager found")
		return Vector2.ZERO
	
	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("no floor tilemap found")
		return Vector2.ZERO

	return floor.return_snapped_local_position(center.get_local_mouse_position()) + build_offset

func get_buildability() -> bool:
	""" check the tower is buildable at its current location and depending on the available resources"""

	# setup reference to level manager to snap to grid
	if not level_manager:
		print_debug("no level manager found")
		return false

	# check if we have enough money
	if not resource_manager:
		print_debug("no resource manager found")
		return false

	# we aleays build a level 1 tower!
	if not tower_build_resource:
		print_debug("no tower build resource found")
		return false
	
	var tower_costs = (tower_build_resource.get_level(0) as TowerLevel).build_costs
	if not tower_costs:
		print_debug("no tower costs found")
		return false

	var floor: Floor = level_manager.get_floor()
	if not floor:
		print_debug("no floor found")
		return false

	if floor.is_tile_buildable(center.get_local_mouse_position()) and tower_costs <= resource_manager.get_gold_amount():
		return true

	return false

func check_build_process() -> void:
	"""render the build preview"""

	if not is_building:
		return

	if not tower_build_preview_instance:
		print_debug("no tower build preview instance found")
		return
	
	tower_build_preview_instance.is_buildable = get_buildability()
	tower_build_preview_instance.global_position = get_build_position()
	
	if tower_build_preview_instance.range_preview:
		tower_build_preview_instance.range_preview.global_position = tower_build_preview_instance.position - Constants.TOWER_BUILD_OFFSET