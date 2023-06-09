extends Resource
class_name TowerResource

# tower resource definition
# detailed configuration of the tower type
# is done inside the tower_scene

@export var id: String
@export var name: String
@export_multiline var description: String
@export var tower_scene: PackedScene

# tower meta information
@export var is_bulldable: bool
@export var build_costs: int
@export var build_icon: Texture

