extends Area2D
class_name HurtboxComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var health_component: HealthComponent

# ========
# class signals
# ========

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


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_area_entered(area: Area2D):
	"""
	detect hits by hitbox components
	"""
	if not area is HitboxComponent:
		return

	print_debug("HurtboxComponent: hit by " + area.name)
	health_component.take_damage((area as HitboxComponent).damage)
	
func _on_area_exited(area: Area2D) -> void:
	if not area is HitboxComponent:
		return

# ========
# class functions
# ========
