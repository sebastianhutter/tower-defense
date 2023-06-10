extends Node2D
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

@export var tile_set_biome: TilesetBiome = TilesetBiome.SPRING
@export var map_size: Vector2i = Vector2i(32, 32)


# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var tilemap: TileMap = %TileMap
@onready var towers: Node2D = %Towers
@onready var enemies: Node2D = %Enemies

# ========
# class vars
# ========

# the origins equal the tilemap tile ids
# adding the tiilesetbiome offset to it will tile for
# the selected biome
enum TileSetOrigins {
	CONSTRUCTION = 100,
	FLOOR = 110,
	FOUNDATION = 120,
	ROAD1 = 200,
	ROAD2 = 210,
	ROAD3 = 220,
	ROAD4 = 230,
	ROAD5 = 240,
	ROAD6 = 250,
	ROAD7 = 260,
	ROAD8 = 270,
	ROAD9 = 280,
	ROAD10 = 290,
	ROAD11 = 300,
}

enum TilesetBiome {
	SPRING = 0,
	DESERT,
	WINTER,
}


var level_floor: Array[Vector2i] = [Vector2i(), Vector2i()]

var floor_height: Vector2i = Vector2i(0, 0)
var floor_width: Vector2i = Vector2i(0, 0)
var floor_north_tile: Vector2i
var floor_south_tile: Vector2i
var floor_west_tile: Vector2i
var floor_east_tile: Vector2i


# ========
# godot functions
# ========

func _ready():
	"""initialize local objects"""

	_game_events.tower_build_started.connect(_on_tower_build_started)
	_game_events.tower_build_completed.connect(_on_tower_build_completed)
	_game_events.tower_sold.connect(_on_tower_sold)
	calculate_floor()



# ========
# signal handler
# ========

func _on_tower_build_started(resource: TowerResource, tower_position: Vector2) -> void:
	""" replace the tile with the construction tile """

	if not tilemap:
		print_debug("LevelManager: No tilemap node found")
		return

	tilemap.set_cell(
		0,
		tilemap.local_to_map(tower_position),
		TileSetOrigins.CONSTRUCTION+tile_set_biome,
		Vector2i(0,0),
	)

func _on_tower_build_completed(resource: TowerResource, tower_position: Vector2) -> void:
	""" replace the tile with the foundation tile """

	if not tilemap:
		print_debug("LevelManager: No tilemap node found")
		return

	tilemap.set_cell(
		0,
		tilemap.local_to_map(tower_position),
		TileSetOrigins.FOUNDATION+tile_set_biome,
		Vector2i(0,0),
	)

func _on_tower_sold(sell_value: int, tower_position: Vector2) -> void:
	""" replace the foundation tile with a floor tile"""

	if not tilemap:
		print_debug("LevelManager: No tilemap node found")
		return

	tilemap.set_cell(
		0,
		tilemap.local_to_map(tower_position),
		TileSetOrigins.FLOOR+tile_set_biome,
		Vector2i(0,0),
	)


# ========
# class functions
# ========

func calculate_floor() -> void:
	if map_size.x % 2 != 0:
		print_debug("LevelManager: Map size must be odd")
		map_size.x += 1
	
	if map_size.y % 2 != 0:
		print_debug("LevelManager: Map size must be odd")
		map_size.y += 1

	# calculate the top left corner of the map
	# and the lower right corner of the map
	# the map is centered around the HQ
	# the height of the floor needs to be doubled as the map is isometric which leads to a
	# "left shift" in the y axis
	floor_width = Vector2i(
		-1 * int(map_size.x / 2),
		int(map_size.x / 2) ,
	)
	floor_height = Vector2i(
		-1 * int(map_size.y / 2),
		int(map_size.y / 2),
	) * 2

	# calculate the most north, south, west and east tiles
	floor_north_tile = Vector2i(floor_width.x,floor_height.x)
	floor_south_tile = Vector2i(floor_width.y-1,floor_height.y-1)
	floor_west_tile = Vector2i(floor_width.x,floor_height.y-1)
	floor_east_tile = Vector2i(floor_width.y-1,floor_height.x+1)


func generate_floor() -> void:
	""" generate a square flooor """

	if not tilemap:
		print_debug("LevelManager: No tilemap node found")
		return

	for x in range(floor_width.x, floor_width.y):
		for y in range(floor_height.x, floor_height.y):
			tilemap.set_cell(
				0,
				Vector2i(x, y),
				TileSetOrigins.FLOOR+tile_set_biome,
				Vector2i(0,0),
			)

func _draw_north_to_south_road() -> void:
	""" draws a straigh road from north to south"""

	# calculate the road leght by adding most north and moust south coordinate
	var road_length = -1*floor_height.x+floor_height.y
	
	# draw the road via simple for loop
	# we need to increase the x coordinate every second iteration
	# to fit the isometric grid
	var x_offset: int = 0
	var y_offset: int = 0
	var loop_counter: int = 0
	for i in road_length:
		if loop_counter == 2:
			x_offset +=1
			loop_counter = 0
		tilemap.set_cell(
			0,
			Vector2i(floor_north_tile.x + x_offset, floor_north_tile.y + y_offset),
			TileSetOrigins.ROAD1+tile_set_biome,
			Vector2i(0,0),
		)
		loop_counter +=1
		y_offset +=1

func _draw_west_to_east_road() -> void:
	""" draws a straigh road from west to east"""

	# calculate the road leght by adding most west and moust east coordinate
	var road_length = (-1*floor_width.x+floor_width.y)*2-1
	
	# draw the road via simple for loop
	# we need to increase the x coordinate every second iteration
	# to fit the isometric grid
	var x_offset: int = 0
	var y_offset: int = 0
	var loop_counter: int = 1 # start loop counter at one so we increase x after the first iteration!
	for i in road_length:
		if loop_counter == 2:
			x_offset +=1
			loop_counter = 0
		tilemap.set_cell(
			0,
			Vector2i(floor_west_tile.x + x_offset, floor_west_tile.y + y_offset),
			TileSetOrigins.ROAD2+tile_set_biome,
			Vector2i(0,0),
		)
		loop_counter +=1
		y_offset -=1

func generate_roads() -> void:
	""" generate roads from the center of the map """ 

	if not tilemap:
		print_debug("LevelManager: No tilemap node found")
		return

	_draw_north_to_south_road()
	_draw_west_to_east_road()

	# set crossroad tile in center
	tilemap.set_cell(
		0,
		Vector2i(0, 0),
		TileSetOrigins.FOUNDATION+tile_set_biome,
		Vector2i(0,0),
	)

func load_level() -> void:
	""" load level resources """

	# ensure all resources are unloaded
	unload_level()
	# generate floor
	generate_floor()
	# generate roads originating from the center tile
	generate_roads()

func unload_level() -> void:
	
	if tilemap:
		tilemap.clear()

	if towers:
		for tower in towers.get_children():
			tower.queue_free()

	# TODO: re-enable when spawners are implemented
	# if enemies:
	# 	for enemy in enemies.get_children():
	# 		enemy.queue_free()
