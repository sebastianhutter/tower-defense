extends Node
class_name MovementComponent

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

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

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var tween_look_at: Tween

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

func fall(body: Character, delta: float) -> void:
	"""fall the body"""
	velocity_component.fall(body.is_on_floor(), gravity * delta)
	velocity_component.move(body)

func move(body: Character, direction: Vector2, delta: float) -> void:
	"""move the body towards the direction"""
	if direction:
		velocity_component.accelerate(direction)
	else:
		velocity_component.decelerate(direction)

	velocity_component.fall(body.is_on_floor(), gravity * delta)
	velocity_component.move(body)

func look_at(body: Character, pos: Vector2, delta: float) -> void:
	""" look at the given position"""

	if pos.x == body.global_position.x and pos.y == body.global_position.y:
		print_debug("MovementComponent: look_at: positions overlap")
		return

		body.look_at(pos)


func get_movement_direction(body: Character, pos: Vector2) -> Vector2:
	"""returns the direction to the given position"""

	return body.global_position.direction_to(pos)
