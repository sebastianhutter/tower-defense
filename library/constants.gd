class_name Constants

const TOWER_RESOURCE_FOLDER = "res://resources/tower"
const FLOOR_RESOURCE_FOLDER = "res://resources/floor"
const SCENE_FLOOR_SELECT_CARD = "res://scenes/menu/floor_select_card/floor_select_card.tscn"
const SCENE_TOWER_CARD = "res://scenes/ui/tower_card/tower_card.tscn"
const SCENE_TOWER_BUILD_PREVIEW = "res://scenes/ui/tower_build_preview/tower_build_preview.tscn"
const SCENE_TOWER_BUILD_CONSTRUCTION_SITE = "res://scenes/tower/construction/tower_under_construction.tscn"
const SCENE_PORTAL_SCENE = "res://scenes/portal/portal.tscn"
const SCENE_FLOATING_TEXT = "res://scenes/components/floating_text/floating_text.tscn"

# the tower manager spawns the towers with this offset to the given position
# this allows us to spawn the towers properly centered!
const TOWER_HQ_OFFSET = Vector2(128, 0)
const TOWER_BUILD_OFFSET = Vector2(0, -64)
const TOWER_CONTEXT_MENU_OFFSET = Vector2(-128, -64)


# values used to calculate the range of towers.
# to have a more or less exact range detection we need 
# to calculate a coliisionpolygon based on a single tiles size
const TOWER_RANGE_POLYGON_BASELINE: PackedVector2Array = [
	# first point, on x axis, pointing "up"
	Vector2(0, -117),
	# second point, on y axis , pointing "right"
	Vector2(127, -43),
	# third point, on x axis, pointing "down"
	Vector2(0, 30),
	# fourth point, on y axis, pointing "left"
	Vector2(-127, -43),
]
# the points on the x axis need to be increased by ca 146 pixels for one tilemap
const TOWER_RANGE_POLYGON_Y_RATIO: int = 146
# the points on the y axis need to be increased by ca 251 pixels for one tilemap
const TOWER_RANGE_POLYGON_X_RATIO: int = 251

