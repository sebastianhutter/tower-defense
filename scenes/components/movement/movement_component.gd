extends Node
class_name MovementComponent

# ========
# singleton references
# ========


# ========
# export vars
# ========

@export var velocity_component: VelocityComponent 

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

func get_velocity() -> Vector2:
	"""get the velocity"""
	return velocity_component.get_velocity()

func move(body: Node2D, direction: Vector2, delta: float) -> void:
	"""move the body towards the direction"""
	if direction:
		velocity_component.accelerate(direction)
	else:
		velocity_component.decelerate(direction)

	velocity_component.move(body)


func get_movement_direction(body: Node2D, pos: Vector2) -> Vector2:
	"""returns the direction to the given position"""

	return body.global_position.direction_to(pos)
