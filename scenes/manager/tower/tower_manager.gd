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

@export var available_towers: Array[TowerResource]

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
	
	if available_towers.size() == 0:
		print_debug("TowerManager: no towers specified, retrieving all towers from custom resources")
		available_towers = _custom_resource_loader.get_tower_resources()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_custom_signal_event():
	pass

# ========
# class functions
# ========

func find_tower(id: String) -> TowerResource:
	"""
	finds the tower with the given id
	"""

	for tower in available_towers:
		if tower.id == id:
			return tower

	return null

func spawn_tower(id: String, pos: Vector2i) -> void:
	"""
	spawns the tower at the given position
	"""

	var tower: TowerResource = find_tower(id)
	if not tower:
		print_debug("TowerManager: could not find tower with id: " + id)
		return
		
	if level_node_towers == null:
		level_node_towers = _helper.get_level_node_towers()
		if level_node_towers == null:
			print_debug("TowerManager: could not find level node towers")
			return

	var tower_scene: Node2D = tower.tower_scene.instantiate()
	
	level_node_towers.add_child(tower_scene)
	tower_scene.position = pos
