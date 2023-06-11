extends Resource
class_name FloorResource

@export var id: Types.Floor
@export var enabled: bool
@export var name: String
@export_multiline var description: String
@export var floor_scene: PackedScene
@export var preview: Texture 

# level resources
@export var gold_amount: int
@export var gold_increase_time: float
@export var gold_increase_amount: int

# level "difficulty"
@export var portal_delay: float 
@export var time: float
@export var waves: int