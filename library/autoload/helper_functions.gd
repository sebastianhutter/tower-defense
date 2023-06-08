extends Node
class_name Helper

#func get_foreground_layer() -> Node3D:
#	"""
#		returns the foreground layer node in the current scene
#	"""
#
#	var layer: Node3D = get_tree().get_first_node_in_group(Types.LayerGroups.foreground) as Node3D
#
#	if layer:
#		return layer
#
#	return null
#
#func get_player() -> Player:
#	"""
#	returns the player node 
#	"""
#
#	var player: Player = get_tree().get_first_node_in_group(Types.LayerGroups.player) as Player
#
#	if player:
#		return player
#
#	return null
#
func get_parent_character(node: Node) -> Character:
	"""
	returns the first found characterbody2d node in the parent tree
	"""

	var parent = node.get_parent()

	if parent:
		if parent is Character:
			return parent

		return get_parent_character(parent)

	return null



func get_hq_position() -> Vector2:
	""" return the position of the player HQ """
	
	var hq_node: Node2D = (get_tree().get_first_node_in_group("hq") as Node2D)
	if not hq_node:
		return Vector2.ZERO
		
	return hq_node.position

func get_level_node_towers() -> Node2D:
	"""return the node containing all towers"""
	return get_tree().get_first_node_in_group('towers')

func get_level_node_enemies() -> Node2D:
	""" return the node containing all enemies"""
	return get_tree().get_first_node_in_group('enemies')
