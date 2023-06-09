# GdUnit generated TestSuite
class_name CustomResourceLoaderTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# cheapish unit tests relaying on abilities availble on the filesystem
# they shouldnt change that often so the tests should run more or less stable

# TestSuite generated from
const __source = 'res://library/autoload/custom_resource_loader.gd'

var custom_resource_loader: CustomResourceLoader

func before_test() -> void:
	"""initialize resources for testing"""

	custom_resource_loader = auto_free(CustomResourceLoader.new())

func test_ability_resources_count() -> void:
	"""ensure all ability resources are loaded"""
	
	# TODO: write own fs find to find all tres files
	assert_array(custom_resource_loader.ability_resources).has_size(2)
	
func test_get_ability_resource() -> void:
	"""ensure we get an ability resource back"""
	var ability_resource = custom_resource_loader.get_ability_resource("shield")
	
	assert_object(ability_resource).is_instanceof(AbilityResource)
	assert_str(ability_resource.id).is_equal("shield")
	
func test_get_ability_resource_null() -> void:
	"""ensure we get null back for a non existing resource"""
	
	var ability_resource = custom_resource_loader.get_ability_resource("thisabilitydoesnotexist")
	assert_object(ability_resource).is_null()

