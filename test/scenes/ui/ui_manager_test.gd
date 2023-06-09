# GdUnit generated TestSuite
class_name UiManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/ui/ui_manager.gd'

func create_scene() -> UiManager:
	"""initializes the unit test scene for the tests"""
	return auto_free(load("res://scenes/ui/ui_manager.tscn").instantiate())

func test_load_ability_cards() -> void:
	""" ensure ability_ui function is called"""
	
	var scene: UiManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)

	scene.ability_ui = mock(AbilityUi) as AbilityUi
	do_return(true).checked(scene.ability_ui).load_ability_cards 
	scene.load_ability_cards()
	
	# TODO: fix verify calls when gdunit4 fixes the mocking
	pass

func test_hide_ui_on_ready() -> void:
	"""ensure all uis are hidden on ready"""
	
	var scene: UiManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	for u in scene.get_children():
		assert_bool(u.visible).is_false()

func test_show_ui() -> void:
	"""ensure all uis are shown after function call"""
	
	var scene: UiManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	scene.show_ui()
	for u in scene.get_children():
		assert_bool(u.visible).is_true()
		
func test_hide_ui() -> void:
	"""ensure all uis are shown after function call"""
	
	var scene: UiManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	scene.show_ui()
	scene.hide_ui()
	for u in scene.get_children():
		assert_bool(u.visible).is_false()
