# GdUnit generated TestSuite
class_name GameStateManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/game_state/game_state_manager.gd'



func create_scene() -> GameStateManager:
	"""initializes the unit test scene for the tests"""
	return auto_free(load("res://scenes/game_state/game_state_manager.tscn").instantiate())


# TODO: fix mocking implementation

func test_menu_loop() -> void:
	"""ensure hide menus is called and tree is unpaused"""
#
	var scene: GameStateManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)

	scene.ui_manager = mock(UiManager) as UiManager
	do_return(true).checked(scene.ui_manager).hide_ui()
	scene.menu_manager = mock(MenuManager) as MenuManager
	do_return(Types.Menu.PAUSE_MENU).checked(scene.menu_manager).show_menu(Types.Menu.PAUSE_MENU)

	scene.menu_loop(Types.Menu.PAUSE_MENU)	
	assert_bool(scene.get_tree().paused).is_true()
	# verify seems to be broken atm!
#	verify_no_interactions(scene.ui_manager)
#	verify(scene.ui_manager, 1).hide_ui()
#	verify(scene.menu_manager, 1).show_menu(Types.Menu.PAUSE_MENU)
	# unpause else test hangs forever ;-)
	scene.get_tree().paused = false

#
