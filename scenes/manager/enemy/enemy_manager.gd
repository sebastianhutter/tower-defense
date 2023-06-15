extends Manager
class_name EnemyManager

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

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

var spawn_tile_positiions: Array[Vector2]

var spawned_once: bool = false

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

	# if enemy_container.get_child_count() > 8:
	# 	return

	# for spawn_tile_position in self.spawn_tile_positiions:
	# 	var enemy = enemy_scene.instantiate()
	# 	enemy.position = spawn_tile_position
	# 	enemy_container.add_child(enemy)

	if spawned_once:
		return

	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_tile_positiions[0]
	enemy_container.add_child(enemy)

	spawned_once = true

# ========
# class functions
# ========

func _enter_game_loop() -> void:
	self.spawn_tile_positiions = level_manager.get_floor().spawn_tile_positions

func _game_loop() -> void:
	spawn_enemies()

func spawn_enemies() -> void:
	""" spawn enemies on the floor """

	pulse.start()


