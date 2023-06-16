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

func attack(pos: Vector2, damage_modifier: float) -> void:
    pass