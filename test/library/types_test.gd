# GdUnit generated TestSuite
class_name TypesTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://library/types.gd'


func test_gamestate_types() -> void:
	
	assert_int(Types.GameState.NONE).is_equal(-1)
	assert_int(Types.GameState.MENU).is_equal(0)
	assert_int(Types.GameState.ENTER_GAME_LOOP).is_equal(1)
	assert_int(Types.GameState.GAME_LOOP).is_equal(2)
	assert_int(Types.GameState.GAME_OVER).is_equal(3)
	assert_int(Types.GameState.LEVEL_END).is_equal(4)
	assert_int(Types.GameState.EXIT_GAME_LOOP).is_equal(5)
	assert_int(Types.GameState.QUIT).is_equal(6)

func test_menu_types() -> void:
	
	assert_int(Types.Menu.MAIN_MENU).is_equal(0)
	assert_int(Types.Menu.OPTIONS_MENU).is_equal(1)
	assert_int(Types.Menu.PAUSE_MENU).is_equal(2)
	assert_int(Types.Menu.ABILITY_SELECT_MENU).is_equal(3)
	assert_int(Types.Menu.LEVEL_SELECT_MENU).is_equal(4)
	assert_int(Types.Menu.LEVEL_END_MENU).is_equal(5)
	assert_int(Types.Menu.GAME_OVER_MENU).is_equal(6)
	
func test_layer_groups() -> void:
	
	assert_dict(Types.LayerGroups).contains_key_value("foreground", "layer_foreground")
	assert_dict(Types.LayerGroups).contains_key_value("entity", "layer_entity")
	assert_dict(Types.LayerGroups).contains_key_value("player", "player")
