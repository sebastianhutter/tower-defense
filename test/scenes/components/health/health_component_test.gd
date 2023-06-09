# GdUnit generated TestSuite
class_name HealthComponentTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/components/health_component.gd'

var health_component: HealthComponent

func before_test() -> void:
	health_component = auto_free(HealthComponent.new())
	health_component._ready()


func test_init() -> void:
	"""
	ensure max health = current health
	"""
	
	assert_float(health_component.max_health).is_equal(health_component.current_health)


func test_take_damage() -> void:
	"""
	ensure damage is taken accordingly
	"""
	
	health_component.current_health = 10
	health_component.take_damage(5)
	assert_float(health_component.current_health).is_equal(5)
	
	
func test_take_damage_clamp() -> void:
	"""
	ensure health cant be lower then 0
	"""
	
	health_component.current_health = 10
	health_component.take_damage(100)
	assert_float(health_component.current_health).is_equal(0)


func test_emit_died_signal_exists() -> void:
	"""
	ensure died signal exists in health component
	"""
	
	assert_signal(health_component).is_signal_exists("died")
	
	

# SIGNAL UNIT TESTS ARE BROKEN ATM
# https://github.com/MikeSchulze/gdUnit4/issues/103
# will be fixed with v41.1.1
# https://github.com/users/MikeSchulze/projects/5/views/6
func test_emit_died_signal_emited() -> void:
	"""
	ensure died signal is emitted when health reaches 0 (test_take_damage takes
	care of this!)
	"""

	health_component.current_health = 10
	health_component.take_damage(100)

	#await assert_signal(health_component).is_emitted("died")
	pass

	
	
