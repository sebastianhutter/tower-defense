# GdUnit generated TestSuite
class_name GamePauseMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/pause_menu/pause_menu.gd'

var menu: GamePauseMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GamePauseMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/pause_menu/pause_menu.tscn").instantiate())

func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("continue_button_pressed")
	assert_signal(menu).is_signal_exists("options_button_pressed")
	assert_signal(menu).is_signal_exists("quit_to_menu_button_pressed")
	
func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GamePauseMenu)
	
func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: CanvasLayer = create_scene()

	var continue_button: Button = scene.get_node("%ContinueButton")
	var options_button: Button = scene.get_node("%OptionsButton")
	var quit_to_menu_button: Button = scene.get_node("%QuitToMenuButton")
	
	assert_object(continue_button).is_not_null()
	assert_object(options_button).is_not_null()
	assert_object(quit_to_menu_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
