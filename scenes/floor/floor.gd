extends Node2D
class_name Floor


# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var portal_scene: PackedScene = preload(Constants.SCENE_PORTAL_SCENE)

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var tile_map: FloorTileMap = $%TileMap
@onready var towers: Node2D = $%Towers
@onready var enemies: Node2D = $%Enemies
@onready var projectiles: Node2D = $%Projectiles


# ========
# class vars
# ========

var floor_resource: FloorResource = null
var spawn_tile_positions: Array[Vector2] = []

# ========
# godot functions
# ========

func _ready():
	
	if tile_map:
		# store all spawn tile positions
		spawn_tile_positions = tile_map.get_local_positon_of_all_tiles_with_custom_data('spawner', true)

	

# ========
# signal handler
# ========

# ========
# class functions
# ========

func initiate(floor_resource: FloorResource) -> void:
	""" configure the floor with the given resource """

	self.floor_resource = floor_resource
	for spawner in spawn_tile_positions:
		setup_portal_scene(spawner)


func setup_portal_scene(pos: Vector2) -> void:
	""" instntiate the spawner portal scene for some animation on the floor """

	var portal: Node2D = portal_scene.instantiate()
	add_child(portal)
	portal.position = pos + Constants.TOWER_BUILD_OFFSET
	# connect the wave_incomfing signal with the portal opening animation
	# so when the first enemy wave arrives the portals are opened up
	_game_events.wave_incoming.connect(portal._on_wave_incoming)
	_game_events.send_wave.connect(portal._on_send_wave)


func place_tile(tile_origin: Types.TileOrigin, local_position: Vector2) -> void:
	""" set a predefined tile at the given position """

	if not tile_map:
		print_debug("Floor::set_tile(): tile_map is not ready")
		return

	tile_map.set_tile_by_local_position(tile_origin, local_position)


func place_construction_tile(local_position: Vector2) -> void:
	""" place the 'under constructon tile' """

	place_tile(Types.TileOrigin.CONSTRUCTION, local_position)


func place_foundation_tile(local_position: Vector2) -> void:
	""" place the 'foundation tile' """

	place_tile(Types.TileOrigin.FOUNDATION, local_position)


func place_floor_tile(local_position: Vector2) -> void:
	""" place the 'floor tile' """

	place_tile(Types.TileOrigin.FLOOR, local_position)


func return_snapped_local_position(original_local_position: Vector2) -> Vector2:
	""" convert the given position to the center of the tile it is in and return the new position """

	if not tile_map:
		print_debug("Floor::return_snapped_local_position(): tile_map is not ready")
		return original_local_position

	var map_position: Vector2i = tile_map.local_to_map(original_local_position)
	return tile_map.map_to_local(map_position)


func is_tile_buildable(local_position: Vector2) -> bool:
	""" return true if the tile is buildable """

	if not tile_map:
		print_debug("Floor::is_tile_buildable(): tile_map is not ready")
		return false

	var is_buildable: Variant = tile_map.get_tile_custom_data_by_local_position(local_position, "buildable")
	if not is_buildable:
		print_debug("Floor::is_tile_buildable(): no custom tile data found")
		return false

	return is_buildable
