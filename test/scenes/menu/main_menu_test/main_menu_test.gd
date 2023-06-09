# GdUnit generated TestSuite
class_name GameMainMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/main_menu/main_menu.gd'

var menu: GameMainMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GameMainMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/main_menu/main_menu.tscn").instantiate())

func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("play_button_pressed")
	assert_signal(menu).is_signal_exists("options_button_pressed")
	assert_signal(menu).is_signal_exists("quit_button_pressed")

func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GameMainMenu)

func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: CanvasLayer = create_scene()

	var play_button: Button = scene.get_node("%PlayButton")
	var options_button: Button = scene.get_node("%OptionsButton")
	var quit_button: Button = scene.get_node("%QuitButton")
	
	assert_object(play_button).is_not_null()
	assert_object(options_button).is_not_null()
	assert_object(quit_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
