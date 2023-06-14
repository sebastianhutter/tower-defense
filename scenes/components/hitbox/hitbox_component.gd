extends Area2D
class_name HitboxComponent

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var damage: float = 1.0

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func _on_area_entered(area: Area2D):
	"""
	detect hits by hitbox components
	"""
	if not area is HurtboxComponent:
		return

	print_debug("HitboxComponent: hit " + area.name)
