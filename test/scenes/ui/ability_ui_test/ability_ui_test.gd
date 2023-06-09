# GdUnit generated TestSuite
class_name AbilityUiTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/ui/ability_ui/ability_ui.gd'



func create_scene() -> AbilityUi:
	"""initializes the unit test scene for the tests"""
	return auto_free(load("res://scenes/ui/ability_ui/ability_ui.tscn").instantiate())

func test_ability_card_container_exists() -> void:
	"""ensure the ability card container is available after ready"""

	var scene: AbilityUi = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)

	assert_object(scene.ability_card_container).is_not_null()
	assert_object(scene.ability_card_container).is_instanceof(HBoxContainer)

func test_packed_scene_exists() -> void:
	"""ensure the packed scene can be loaded"""
	
	var scene: AbilityUi = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)

	assert_object(scene.ability_card_scene).is_not_null()
	assert_object(scene.ability_card_scene).is_instanceof(PackedScene)

func test_load_ability_card_container() -> void:
	""" test the ability card container load function """
	
	var scene: AbilityUi = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	scene._player_data.selected_ability_ids.clear()
	scene._player_data.selected_ability_ids.append("shield")
	scene.load_ability_cards()
	
	var ability_cards: Array[Node] =  scene.ability_card_container.get_children()
	assert_array(ability_cards).has_size(1)
	
	assert_object(ability_cards[0]).is_instanceof(AbilityCard)
	assert_str((ability_cards[0] as AbilityCard).ability_id).is_equal('shield')

func test_load_ability_card_container_not_null() -> void:
	"""load ability cards if container is not empty, should not change the current container!"""
	
	var scene: AbilityUi = create_scene()
	var runner: GdUnitSceneRunner = scene_runner(scene)
	
	# add a single node to the ability card container
	var node: Node = Node.new()
	scene.ability_card_container.add_child(node)
	node.name = "testnode"
	
	# run the load function, the container shouldnt be changed anymore
	scene.load_ability_cards()
	
	scene._player_data.selected_ability_ids.clear()
	scene._player_data.selected_ability_ids.append("shield")
	scene.load_ability_cards()
	
	assert_array(scene.ability_card_container.get_children()).contains_exactly([node])
	
	
