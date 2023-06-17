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

func test_floor_resources_count() -> void:
	"""ensure all floor resources are loaded"""
	
	assert_array(custom_resource_loader.floor_resources).has_size(3)
	

