# GdUnit generated TestSuite
class_name ConstantsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://library/constants.gd'

func test_scene_floor_select_card() -> void:
	assert_file(Constants.SCENE_FLOOR_SELECT_CARD).exists()

func test_scene_tower_card() -> void:
	assert_file(Constants.SCENE_TOWER_CARD).exists()

func test_scene_tower_build_preview() -> void:
	assert_file(Constants.SCENE_TOWER_BUILD_PREVIEW).exists()

func test_scene_tower_build_construction_site() -> void:
	assert_file(Constants.SCENE_TOWER_BUILD_CONSTRUCTION_SITE).exists()

func test_scene_portal_scene() -> void:
	assert_file(Constants.SCENE_PORTAL_SCENE).exists()

func test_scene_floating_text() -> void:
	assert_file(Constants.SCENE_FLOATING_TEXT).exists()
