# GdUnit generated TestSuite
class_name GameCameraTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/game_camera/game_camera.gd'

func create_scene() -> Node2D:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://test/tscn/scenes/game_camera/game_camera_test.tscn").instantiate())

func test_camera() -> void:
	
	var scene: Node2D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	var game_camera = scene.get_node("GameCamera") as GameCamera

	assert_bool(game_camera.is_current()).is_true()
