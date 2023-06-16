extends Node
class_name VelocityComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var max_speed: float = 100.0

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var velocity: Vector2 = Vector2.ZERO

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
	"""returns the velocity"""

	return velocity
	
func accelerate(direction: Vector2) -> void:
	"""accelerate into the given direction"""

	if direction == Vector2.ZERO:
		return
		
	velocity = direction * max_speed


func decelerate(direction: Vector2) -> void:
	"""deacclerate"""

	if direction != Vector2.ZERO:
		return

	velocity.x = move_toward(velocity.x, 0.0, max_speed)
	velocity.y = move_toward(velocity.y, 0.0, max_speed)
