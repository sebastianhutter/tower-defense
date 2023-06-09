extends Node
class_name TowerManager

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

# ========
# class onready vars
# ========

# @onready var my_label: Label = $%Label

# ========
# class vars
# ========

var level_node_towers = null


# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if _game_events:
		_game_events.tower_build_completed.connect(_on_tower_build_completed)


# ========
# signal handler
# ========

func _on_tower_build_completed(resource: TowerResource, tower_position: Vector2) -> void:
	""" game event from build manager - lets place a tower at the given position"""

	spawn_tower(resource, tower_position)


# ========
# class functions
# ========

func find_tower(id: String) -> TowerResource:
	"""
	finds the tower with the given id
	"""

	for tower in _custom_resource_loader.get_tower_resources():
		if tower.id == id:
			return tower

	return null


func spawn_tower_by_id(id: String, pos: Vector2) -> void:
	"""
	spawns the tower with the given id at the given position
	"""

	var tower: TowerResource = find_tower(id)
	if not tower:
		print_debug("TowerManager: could not find tower with id: " + id)
		return

	spawn_tower(tower, pos)
	

func spawn_tower(resource: TowerResource, pos: Vector2) -> void:
	"""
	spawns the tower at the given position
	"""
		
	if level_node_towers == null:
		level_node_towers = _helper.get_level_node_towers()
		if level_node_towers == null:
			print_debug("TowerManager: could not find level node towers")
			return

	var tower_scene: Tower = resource.tower_scene.instantiate() as Tower
	tower_scene.set_tower_resource(resource)
	level_node_towers.add_child(tower_scene)
	tower_scene.position = pos

