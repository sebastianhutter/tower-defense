# GdUnit generated TestSuite
class_name UiManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/manager/ui/ui_manager.gd'

func create_scene() -> UiManager:
	"""initializes the unit test scene for the tests"""
	return auto_free(load("res://scenes/manager/ui/ui_manager.tscn").instantiate())


func test_show_ui() -> void:
	"""ensure all uis are shown after function call"""
	
	var scene: UiManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	scene.show_ui()
	for u in scene.get_children():
		assert_bool(u.visible).is_true()
		
