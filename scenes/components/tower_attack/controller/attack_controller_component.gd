extends Node2D
class_name AttackControllerComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var projectile_scene: PackedScene

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var parent_node: Node2D

# ========
# godot functions
# ========

func _ready() -> void:

	set_projectile_parent_node()

# ========
# class functions
# ========

func set_projectile_parent_node() -> void:
	""" tries to get the parent node from the group 'projectiles' """

	var parent: Node2D = get_tree().get_first_node_in_group('projectiles')
	if not parent:
		parent_node = self

	parent_node = parent

# basic attack function, could be changed by the different controllers
func attack(pos: Vector2, damage_modifier: float) -> void:

		if not projectile_scene:
			print_debug("no projectile_scene found")
			return
		
		var p = projectile_scene.instantiate() as Projectile
		p.global_position = global_position
		p.set_damage_modifier(damage_modifier)
		p.look_at(pos)
		parent_node.add_child(p)
		
		
		
	
