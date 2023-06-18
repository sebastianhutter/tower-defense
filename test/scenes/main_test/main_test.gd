# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/main/main.gd'

func create_scene() -> Main:
	"""initializes the unit test scene for the tests"""
	return auto_free(load("res://scenes/main/main.tscn").instantiate())

func test_managers_registered() -> void:
	"""ensure the required amount of managers are registered and none are null"""

	var scene: Main = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	assert_int(scene.get_child_count()).is_equal(4)
	for child in scene.get_children():
		assert_object(child).is_not_null()
		
	# the main scene loads the menu, so we need to unpause the scene tree!
	scene.get_tree().paused = false
	
