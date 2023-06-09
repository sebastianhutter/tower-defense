# GdUnit generated TestSuite
class_name GameAbilitySelectMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/menu/ability_select_menu/ability_select_menu.gd'

var menu: GameAbilitySelectMenu

func before_test() -> void:
	"""prepare test resources"""

	menu = auto_free(GameAbilitySelectMenu.new())

func create_scene() -> CanvasLayer:
	"""initializes the unit test scene for the tests"""

	return auto_free(load("res://scenes/menu/ability_select_menu/ability_select_menu.tscn").instantiate())


func test_signals() -> void:
	"""ensure the required signals exist"""

	assert_signal(menu).is_signal_exists("level_select_button_pressed")
	assert_signal(menu).is_signal_exists("back_button_pressed")
	

func test_menu_type() -> void:
	"""ensure the loaded menu has the correct script assigned"""
	
	assert_object(create_scene()).is_instanceof(GameAbilitySelectMenu)

func test_button_existence() -> void:
	"""ensure the buttons exist"""

	var scene: CanvasLayer = create_scene()

	var select_button: Button = scene.get_node("%LevelSelectButton")
	var back_button: Button = scene.get_node("%BackButton")
	
	assert_object(select_button).is_not_null()
	assert_object(back_button).is_not_null()
	
# TODO: implement emit signal check for buttons when gdunit4 fix is released
