extends CanvasLayer

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var vignette_min_intensity: float = 0.65
@export var vignette_max_intensity: float = 5.0

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var color_rect: ColorRect = $%ColorRect

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	set_intensity(vignette_min_intensity)
	_game_events.hq_hit.connect(_on_hq_hit)
	_game_events.defeat.connect(_on_round_end)
	_game_events.victory.connect(_on_round_end)


# ========
# signal handler
# ========

func _on_hq_hit(health_left: float):
	""" increase the vignette itensity the lower the players hq health """
	var new_intensity: float = clamp(1.0 / health_left, vignette_min_intensity, vignette_max_intensity)
	set_intensity(new_intensity)

func _on_round_end() -> void:
	set_intensity(vignette_min_intensity)
	

# ========
# class functions
# ========

func set_intensity(intensity: float) -> void:
	color_rect.material.set_shader_parameter("vignette_intensity", intensity)
