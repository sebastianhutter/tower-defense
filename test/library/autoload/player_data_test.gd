# GdUnit generated TestSuite
class_name PlayerDataTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://library/autoload/player_data.gd'

var player_data: PlayerData

func before_test() -> void:
	"""initialize resources for testing"""

	player_data = auto_free(PlayerData.new())

func test_get_selected_abilities() -> void:
	
	player_data.selected_ability_ids = ["sa1", "sa2"]
	var selected_abilities: Array[String] = player_data.get_selected_abilities()
	
	assert_array(selected_abilities).contains_exactly(["sa1", "sa2"])


func test_get_available_ability_ids() -> void:
	
	player_data.available_ability_ids = ["a1", "a2"]
	
	var available_abilities: Array[String] = player_data.get_available_abilities()
	
	assert_array(available_abilities).contains_exactly(["a1", "a2"])
