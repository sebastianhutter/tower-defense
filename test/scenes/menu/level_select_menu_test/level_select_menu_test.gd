# GdUnit generated TestSuite
class_name GameLevelSelectMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/level_select_menu/level_select_menu.gd'

var menu: GameLevelSelectMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GameLevelSelectMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/level_select_menu/level_select_menu.tscn").instantiate())

func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("enter_tower_button_pressed")
	assert_signal(menu).is_signal_exists("back_button_pressed")

func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GameLevelSelectMenu)

func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: CanvasLayer = create_scene()

	var enter_tower_button: Button = scene.get_node("%EnterTower")
	var back_button: Button = scene.get_node("%BackButton")
	
	assert_object(enter_tower_button).is_not_null()
	assert_object(back_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
