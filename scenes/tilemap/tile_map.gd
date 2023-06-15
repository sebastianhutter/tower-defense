extends TileMap
class_name FloorTileMap

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

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

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func set_tile_by_local_position(tile_id: int, tile_local_position: Vector2) -> void:
	""" sets a tile at the given position """

	var tile_position: Vector2i = local_to_map(tile_local_position)
	var tile_biome_id: int = tile_id + tilemap_biome

	set_cell(
		0,
		tile_position,
		tile_biome_id,
		Vector2.ZERO,
	)

func get_tile_by_data_by_local_position(tile_local_position: Vector2) -> TileData:
	""" returns the tile data at the given position """

	var tile_position: Vector2i = local_to_map(tile_local_position)
	var tile_data: TileData = get_cell_tile_data(0, tile_position)

	if not tile_data:
		print_debug("TileMap", "get_tile_by_data_by_local_position", "no tile data found at tile_pos: " + str(tile_position))
		return null

	return tile_data


func get_tile_custom_data_by_local_position(tile_local_position: Vector2, custom_data_key: String) -> Variant:
	""" returns the custom data at the given position """

	var tile_position: Vector2i = local_to_map(tile_local_position)
	var tile_data: TileData = get_cell_tile_data(0, tile_position)

	if not tile_data:
		print_debug("TileMap", "get_custom_data_by_local_position", "no tile data found at tile_pos: " + str(tile_position))
		return null

	var custom_data: Variant = tile_data.get_custom_data(custom_data_key)
	if custom_data == null:
		print_debug("TileMap", "get_custom_data_by_local_position", "no custom tile data found " + str(tile_position))
		return null

	return custom_data

func get_local_positon_of_all_tiles_with_custom_data(custom_data_key: String, custom_data_value: Variant) -> Array[Vector2]:
	""" returns an array of all tile positions that have the given custom data """

	var tile_positions: Array[Vector2] = []

	for tile_position in get_used_cells(0):
		var tile_data: TileData = get_cell_tile_data(0, tile_position)
		var custom_data: Variant = tile_data.get_custom_data(custom_data_key)

		if not custom_data:
			continue

		if custom_data != custom_data_value:
			continue

		tile_positions.append(map_to_local(tile_position))

	return tile_positions