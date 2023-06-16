extends AttackControllerComponent
class_name AttackControllerComponentHQ

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func attack(pos: Vector2, damage_modifier: float) -> void:

	if not projectile_scene:
		print_debug("no projectile_scene found")
		return
	
	var p = projectile_scene.instantiate() as Projectile
	print(p)
	p.global_position = global_position
	p.set_damage_modifier(damage_modifier)
	p.set_target_position(pos)
	p.look_at(pos)
	parent_node.add_child(p)
	
	
	
