extends Node
class_name HealthComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var max_health: float = 10.0

# ========
# class signals
# ========

signal died()
signal health_changed()

# ========
# class onready vars
# ========


# ========
# class vars
# ========

var current_health: float

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========


# ========
# class functions
# ========

func take_damage(damage: float) -> void:
	current_health = max(current_health - damage, 0)
	health_changed.emit()

	if current_health == 0:
		print_debug("HealthComponent: died")
		died.emit()

func get_health_percent() -> float:
	""" return normalized health value """
	if current_health <= 0:
		return 0

	return min(current_health/max_health, 1)