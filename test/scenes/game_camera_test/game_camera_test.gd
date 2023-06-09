# GdUnit generated TestSuite
class_name GameCameraTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/game_camera/game_camera.gd'

func create_scene() -> Node3D:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://test/tscn/scenes/game_camera/game_camera_test.tscn").instantiate())

func test_camera_offset() -> void:
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	var game_camera = scene.get_node("GameCamera") as GameCamera
	
	# player is at pos 0,0,0
	# camera is at pos 0,10,10
	# offset should be 0,10,10 after initi
	assert_vector3(game_camera.camera_offset).is_equal(game_camera.global_position)
