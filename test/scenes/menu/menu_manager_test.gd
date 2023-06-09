# GdUnit generated TestSuite
class_name MenuManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/menu_manager.gd'

var menu_manager: MenuManager

var menus_to_test = {
	"%MainMenu": GameMainMenu,
	"%PauseMenu": GamePauseMenu,
	"%OptionsMenu": GameOptionsMenu,
	"%AbilitySelectMenu": GameAbilitySelectMenu,
	"%LevelSelectMenu": GameLevelSelectMenu,
}

func before_test() -> void:
	"""prepare test resources"""

	menu_manager = auto_free(MenuManager.new())

func create_scene() -> MenuManager:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/menu_manager.tscn").instantiate())

func test_scene_type() -> void:
	"""ensure the menu manager has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(MenuManager)

func test_menu_existence() -> void:
	"""ensure all menus are loaded in scene"""
	
	var scene: MenuManager = create_scene()
	
	for menu in menus_to_test:
		var m = scene.get_node(menu)
		assert_object(m).is_not_null()
		assert_object(m).is_instanceof(menus_to_test[menu])

func test_menu_are_hidden_on_ready() -> void:
	"""ensure all menus are hidden when the manager becomes ready"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	for menu in menus_to_test:
		var m = scene.get_node(menu)
		assert_bool(m.visible).is_false()
		
func test_menu_stack_is_empty_on_ready() -> void:
	"""ensure menu stack is empty after ready"""

	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	assert_array(scene.menu_stack).is_empty()

func test_resolve_menu() -> void:
	"""ensure resolve menu function returns a valid menu"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene) # scene needs to run for ready vars
	var resolved_menu = scene.resolve_menu_enum(Types.Menu.MAIN_MENU)
	
	assert_object(resolved_menu).is_instanceof(GameMainMenu)
	
func test_resolve_menu_null() -> void:
	"""ensure null is returned if invalid menu is resolved"""

	var scene: MenuManager = create_scene()
	var resolved_menu = scene.resolve_menu_enum(-99)
	
	assert_object(resolved_menu).is_null()

func test_show_menu() -> void:
	"""ensure given menu is visible and in stack"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene) 
	
	scene.show_menu(Types.Menu.MAIN_MENU)

	assert_bool(scene.main_menu.visible).is_true()
	assert_array(scene.menu_stack).contains_exactly([scene.main_menu])
	

func test_show_dupblicate_menu() -> void:
	"""the current implementation of the menu manager allows the same menu
	to be in the stack multiple times. this could cause troublez along the 
	line but as the menu manager is event driven it should never happen that
	the same menu is in there twice
	
	this test simulates that anyway and needs to be fixed if the behaviour is 
	changed
	"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene) 
	
	scene.show_menu(Types.Menu.MAIN_MENU)
	scene.show_menu(Types.Menu.MAIN_MENU)
	
	assert_array(scene.menu_stack).contains_exactly([scene.main_menu, scene.main_menu])
	

func test_show_last_menu() -> void:
	"""ensure the show last menu function handles visibility and stack"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene) 
	
	# add two menus
	scene.show_menu(Types.Menu.MAIN_MENU)
	scene.show_menu(Types.Menu.OPTIONS_MENU)
	
	scene.show_last_menu()
	assert_bool(scene.options_menu.visible).is_false()
	assert_bool(scene.main_menu.visible).is_true()
	assert_array(scene.menu_stack).contains_exactly([scene.main_menu])
	
	# do the same test with three menus
	scene.hide_menus()
	scene.show_menu(Types.Menu.MAIN_MENU)
	scene.show_menu(Types.Menu.ABILITY_SELECT_MENU)
	scene.show_menu(Types.Menu.LEVEL_SELECT_MENU)
	
	scene.show_last_menu()
	assert_bool(scene.main_menu.visible).is_false()
	assert_bool(scene.ability_select_menu.visible).is_true()
	assert_bool(scene.level_select_menu.visible).is_false()
	assert_array(scene.menu_stack).contains_exactly([scene.main_menu, scene.ability_select_menu])
	
	
func test_handle_escape_keys_with_stack() -> void:
	"""ensure the escabe key executes the show last menu function if stack contains two or more
	menus"""
	
	var scene: MenuManager = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene) 
	
	# add two menus
	scene.show_menu(Types.Menu.MAIN_MENU)
	scene.show_menu(Types.Menu.OPTIONS_MENU)
	
	scene.handle_escape_key()
	assert_bool(scene.options_menu.visible).is_false()
	assert_bool(scene.main_menu.visible).is_true()
	assert_array(scene.menu_stack).contains_exactly([scene.main_menu])
	
	
	
	
# TODO: fix up emit signal tests when gdunit4 fix is out!
# this then al
