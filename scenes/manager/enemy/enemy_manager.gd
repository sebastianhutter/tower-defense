extends Node
class_name EnemyManager

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

@export var level_manager: LevelManager = null

# ========
# class signals
# ========


# ========
# class onready vars
# ========

@onready var pulse: Timer = $%Pulse
@onready var enemy_scene: PackedScene = preload("res://scenes/character/enemy/enemy.tscn")

# ========
# class vars
# ========

var floor_resource: FloorResource = null
var spawn_tile_positiions: Array[Vector2]



# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	pulse.timeout.connect(_on_pulse_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_pulse_timeout() -> void:

	var enemy_container: Node2D = _helper.get_level_node_enemies()

	if enemy_container.get_child_count() > 8:
		return

	for spawn_tile_position in self.spawn_tile_positiions:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_tile_position
		enemy_container.add_child(enemy)


# ========
# class functions
# ========

func load_floor(floor_resource: FloorResource) -> void:
	""" initialize enemy manager object """
	
	# store floor information and retrieve spawn tile positions
	self.floor_resource = floor_resource
	self.spawn_tile_positiions = level_manager.get_floor().spawn_tile_positions


func spawn_enemies() -> void:
	""" spawn enemies on the floor """

	pulse.start()


