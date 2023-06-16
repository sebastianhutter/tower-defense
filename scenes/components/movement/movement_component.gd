extends Node
class_name MovementComponent

# ========
# singleton references
# ========


# ========
# export vars
# ========

@export var speed: float = 100.0

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


func move(target_position: Vector2, delta: float) -> void:
	""" move the parent node towards the position """

	# there is no stopping as the enemies will despawn once they hit the hq
	(owner as Area2D).look_at(target_position)
	(owner as Area2D).position += (owner as Area2D).transform.x * speed * delta