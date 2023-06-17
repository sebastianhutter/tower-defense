# GdUnit generated TestSuite
class_name GameFloorSelectMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/floor_select_menu/floor_select_menu.gd'

var menu: GameFloorSelectMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GameFloorSelectMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/floor_select_menu/floor_select_menu.tscn").instantiate())

func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("start_game_button_pressed")
	assert_signal(menu).is_signal_exists("back_button_pressed")

func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GameFloorSelectMenu)

func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: GameFloorSelectMenu = create_scene()

	var start_game_button: Button = scene.get_node("%StartGameButton")
	var back_button: Button = scene.get_node("%BackButton")
	
	assert_object(start_game_button).is_not_null()
	assert_object(back_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
