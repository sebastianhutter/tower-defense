extends CharacterBody2D
class_name Character

# ========
# singleton references
# ========

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

# @onready var my_label: Label = $%Label

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

func get_hurtbox() -> HurtboxComponent:
	"""returns the characters hurtbox if aviailable"""

	return get_node("HurtboxComponent")

func get_hitbox() -> HitboxComponent:
	"""returns the characters hurtbox if aviailable"""

	return get_node("HitboxComponent")
