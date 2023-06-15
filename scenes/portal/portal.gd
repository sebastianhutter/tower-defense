extends Node2D
class_name Portal

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

# ========
# class signals
# ========

signal portal_ready(position: Vector2)

# ========
# class onready vars
# ========

@onready var sprite: Sprite2D = $%Sprite
@onready var timer: Timer = $%Timer
@onready var animation_player: AnimationPlayer = $%AnimationPlayer

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if sprite:
		sprite.hide()

	if timer:
		timer.timeout.connect(_on_timer_timeout)

# ========
# signal handler
# ========

func _on_timer_timeout():
	animation_player.play("portal")

# ========
# class functions
# ========

func initiate(wave_initial_delay: float) -> void:

	if not timer:
		print_debug("Portal: timer not found")
		return

	if not animation_player:
		print_debug("Portal: animation_player not found")
		return

	timer.wait_time = wave_initial_delay
	timer.start()

func animation_finished() -> void:
	portal_ready.emit(position)