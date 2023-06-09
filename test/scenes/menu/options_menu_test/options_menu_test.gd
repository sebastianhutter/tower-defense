# GdUnit generated TestSuite
class_name GameOptionsMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/options_menu/options_menu.gd'

var menu: GameOptionsMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GameOptionsMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/options_menu/options_menu.tscn").instantiate())

func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("back_button_pressed")

func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GameOptionsMenu)

func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: CanvasLayer = create_scene()

	var back_button: Button = scene.get_node("%BackButton")
	
	assert_object(back_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
