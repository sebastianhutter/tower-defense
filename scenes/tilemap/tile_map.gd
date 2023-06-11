extends TileMap
class_name FloorTileMap

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

@export var tilemap_biome: TilesetBiomes

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# the tilemap biome (grass, winter or desert)
# this is used to offset the tileset origins
# to autoplace the correct tiles when a tower is placed or sold
enum TilesetBiomes {
	GRASS = 0,
	DESERT = 1,
	WINTER = 2,
}

# the origins equal the tilemap tile ids
# adding the tiilesetbiome offset to it will tile for
# the selected biome
enum TileSetOrigins {
	SPAWNER = 90,
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


# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func is_tile_buildable(tile_pos: Vector2i) -> bool:
	""" checks if the tile is buildable """

	var tile_data: TileData = get_cell_tile_data(0, tile_pos)
	if not tile_data:
		print_debug("TileMap", "is_tile_buildable", "no tile data found at tile_pos: " + str(tile_pos))
		return false

	var is_buildable = tile_data.get_custom_data('buildable')
	if is_buildable == null:
		print_debug("TileMap", "is_tile_buildable", "no custom tile data found " + str(tile_pos))
		return false

	return is_buildable


func disable_building_on_tile(tile_pos: Vector2i) -> void:
	""" sets 'buildable' to false for the tile """

	var tile_data: TileData = get_cell_tile_data(0, tile_pos)
	if not tile_data:
		print_debug("TileMap", "is_tile_buildable", "no tile data found at tile_pos: " + str(tile_pos))
		return

	tile_data.set_custom_data('buildable', false) 
