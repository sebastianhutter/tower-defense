# GdUnit generated TestSuite
class_name HelperTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://library/autoload/helper_functions.gd'

func create_scene() -> Node3D:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://test/tscn/library/autoload/helper_functions_test.tscn").instantiate())

func test_get_foreground_layer() -> void:
	"""ensure the heloper function finds and returns the foreground layer"""
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper

	var foreground_layer: Node3D = helper.get_foreground_layer()

	assert_object(foreground_layer).is_not_null()
	assert_str(foreground_layer.name as String).is_equal("Foreground")
	
func test_get_foreground_layer_null() -> void:
	"""ensure null is returned if no foreground layer is found"""
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	scene.get_node("Foreground").queue_free()
	await runner.simulate_frames(1) # queue_free removes the node on the next frame
	
	var foreground_layer: Node3D = helper.get_foreground_layer()
	assert_object(foreground_layer).is_null()

func test_get_player() -> void:
	"""ensure the player character is returned"""
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	var player: Player = helper.get_player()
	
	assert_object(player).is_not_null()
	assert_object(player).is_instanceof(Player)
	
func test_get_player_null() -> void:
	"""ensure null is returned if no player exists in the scene"""
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	scene.get_node("Player").queue_free()
	await runner.simulate_frames(1) # queue_free removes the node on the next frame
	
	var player: Player = helper.get_player()
	
	assert_object(player).is_null()
	
func test_get_parent_character_null() -> void:
	"""ensure get_parent_character returns 0 if there is no Character object as parent in the tree"""

	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	var parent: Character = helper.get_parent_character(scene.get_node("ParentCharacter"))
	
	assert_object(parent).is_null()
	
	
func test_get_parent_character() -> void:
	"""ensure a parent characer is returned """
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	var parent: Character = helper.get_parent_character(scene.get_node("ParentCharacter/ParentCharacterA/ParentCharacterANode"))
	
	assert_object(parent).is_not_null()
	assert_object(parent).is_instanceof(Character)
	assert_str(parent.name as String).is_equal("ParentCharacterA")

func test_get_parent_character_nested() -> void:
	"""ensure the closest parent character is returned"""
	
	var scene: Node3D = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	var helper: Helper = scene.get_node("/root/HelperSingleton") as Helper
	
	var parent: Character = helper.get_parent_character(scene.get_node("ParentCharacter/ParentCharacterA/ParentCharacterANode/ParentCharacterB/ParentCharacterBNode/ParentCharacterBNodeNested"))
	
	assert_object(parent).is_not_null()
	assert_object(parent).is_instanceof(Character)
	assert_str(parent.name as String).is_equal("ParentCharacterB")
	

	#
