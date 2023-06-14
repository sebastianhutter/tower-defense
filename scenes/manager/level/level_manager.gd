extends Node
class_name LevelManager

# Generates a new level based on some input parameters

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

# @onready var tilemap: TileMap = %TileMap
# @onready var towers: Node2D = %Towers
# @onready var enemies: Node2D = %Enemies

# ========
# class vars
# ========

var floor_resource: FloorResource = null
var floor_instance: Floor = null

# enum TilesetBiome {
# 	SPRING = 0,
# 	DESERT,
# 	WINTER,
# }


# var level_floor: Array[Vector2i] = [Vector2i(), Vector2i()]

# var floor_height: Vector2i = Vector2i(0, 0)
# var floor_width: Vector2i = Vector2i(0, 0)
# var floor_north_tile: Vector2i
# var floor_south_tile: Vector2i
# var floor_west_tile: Vector2i
# var floor_east_tile: Vector2i


# ========
# godot functions
# ========

func _ready():
	"""initialize local objects"""

	_game_events.tower_build_started.connect(_on_tower_build_started)
	_game_events.tower_build_completed.connect(_on_tower_build_completed)
	_game_events.tower_sold.connect(_on_tower_sold)


# ========
# signal handler
# ========

func _on_tower_build_started(resource: TowerResource, tower_position: Vector2) -> void:
	""" replace the tile with the construction tile """

	if not floor_instance:
		print_debug("LevelManager: No floor node found")
		return

	floor_instance.place_construction_tile(tower_position)

func _on_tower_build_completed(resource: TowerResource, tower_position: Vector2) -> void:
	""" replace the tile with the foundation tile """

	if not floor_instance:
		print_debug("LevelManager: No floor node found")
		return

	floor_instance.place_foundation_tile(tower_position)

func _on_tower_sold(sell_value: int, tower_position: Vector2) -> void:
	""" replace the foundation tile with a floor tile"""

	if not floor_instance:
		print_debug("LevelManager: No floor node found")
		return

	floor_instance.place_floor_tile(tower_position)

# ========
# class functions
# ========

func load_floor(floor_resource: FloorResource) -> void:
	""" create a floor instance with tilemap etc """
	
	if not floor_resource.floor_scene:
		print_debug("LevelManager: No floor scene found")
		return
	
	floor_instance = floor_resource.floor_scene.instantiate() as Floor
	add_child(floor_instance)
	floor_instance.name = "Floor"
	floor_instance.initiate(floor_resource)


func unload_floor() -> void:
	""" unload the floor instance """

	if not floor_instance:
		print_debug("LevelManager: No floor node found")
		return

	floor_instance.queue_free()
	floor_instance = null

func get_floor() -> Floor:
	return floor_instance

