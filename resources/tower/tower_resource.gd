extends Resource
class_name TowerResource

# tower resource definition
# detailed configuration of the tower type
# is done inside the tower_scene

@export var id: Types.Tower
@export var name: String
@export_multiline var description: String
@export var tower_scene: PackedScene

# tower meta information
@export var can_be_build: bool
@export var can_be_sold: bool
@export var can_be_upgraded: bool = true

# icon to use for build preview
@export var build_icon: Texture

# tower level definitions
# each tower should have at least one level defined
# to make it placeable!
@export var levels: Array[TowerLevel] = []

func get_level(level_number: int) -> TowerLevel:

	if level_number >= len(levels):
		return null

	return levels[level_number]
