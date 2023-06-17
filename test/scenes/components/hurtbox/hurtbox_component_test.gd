# GdUnit generated TestSuite
class_name HurtboxComponentTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')


var other_area2d: Area2D
var hitbox_component: HitboxComponent
var hurtbox_component: HurtboxComponent

func before_test() -> void:
	other_area2d = auto_free(Area2D.new())
	hitbox_component = auto_free(HitboxComponent.new())
	hurtbox_component = auto_free(HurtboxComponent.new())
	
	hurtbox_component.health_component = auto_free(HealthComponent.new())
	hurtbox_component.health_component.current_health = 10

func test_on_area_entered_other_area2d() -> void:
	"""
	ensure function is only executed if hitbox component enters
	"""
	
	hurtbox_component._on_area_entered(other_area2d)
	assert_float(hurtbox_component.health_component.current_health).is_equal(10)
	

func test_on_area_entered_hitbox_component() -> void:
	"""
	ensure damage is taken when a hitbox enters the hurtbox area
	"""
	
	hurtbox_component._on_area_entered(hitbox_component)
	assert_float(hurtbox_component.health_component.current_health).is_less(10)
