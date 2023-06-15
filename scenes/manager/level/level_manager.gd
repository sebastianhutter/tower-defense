extends Manager
class_name LevelManager

# Generates a new level based on some input parameters

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

# ========
# export vars
# ========

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var floor_instance: Floor = null

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

func _enter_game_loop() -> void:
	""" start the game loop """

	load_floor()

func _exit_game_loop() -> void:
	""" stop the game loop """

	unload_floor()

func load_floor() -> void:
	""" create a floor instance with tilemap etc """
	
	if not _game_data.selected_floor.floor_scene:
		print_debug("LevelManager: No floor scene found")
		return
	
	floor_instance = _game_data.selected_floor.floor_scene.instantiate() as Floor
	add_child(floor_instance)
	floor_instance.name = "Floor"
	floor_instance.initiate(_game_data.selected_floor)


func unload_floor() -> void:
	""" unload the floor instance """

	if not floor_instance:
		print_debug("LevelManager: No floor node found")
		return

	floor_instance.queue_free()
	floor_instance = null

func get_floor() -> Floor:
	return floor_instance

