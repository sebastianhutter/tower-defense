extends Area2D
class_name HitboxComponent

# ========
# singleton references
# ========

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
