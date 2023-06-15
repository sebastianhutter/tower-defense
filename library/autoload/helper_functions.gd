extends Node
class_name Helper



# TODO: remove dependency to helper functions from tower_upgrade_component
func get_main_node() -> Node:
	""" return the main node """
	return get_tree().get_root().get_node('Main')

func get_resource_manager() -> ResourceManager:
	""" return the resource manager """

	var main: Node = get_main_node()
	if not main:
		print_debug("Main node not found")
		return null

	return main.get_node('ResourceManager') as ResourceManager

