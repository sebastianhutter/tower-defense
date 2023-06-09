# GdUnit generated TestSuite
class_name VelocityComponentTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/components/velocity/velocity_component.gd'


var velocity_component: VelocityComponent

func before_test() -> void:
	velocity_component = auto_free(VelocityComponent.new())
	velocity_component.max_speed = 10.0

func test_accelerate_in_direction() -> void:
	"""
	Tests the accelerate_in_direction method.
	"""

	# delta is not applied at the moment so we can ignore it
	velocity_component.accelerate(Vector3(1, 0, 1))
	assert_vector3(velocity_component.velocity).is_equal(Vector3(10, 0, 10))
