extends Node
class_name HealthComponent

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper

# ========
# export vars
# ========

@export var max_health: float = 10.0

# ========
# class signals
# ========

signal died

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

	if current_health == 0:
		print_debug("HealthComponent: died")
		died.emit()
