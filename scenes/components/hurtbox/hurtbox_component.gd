extends Area3D
class_name HurtboxComponent

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

@export var health_component: HealthComponent

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


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_area_entered(area: Area3D):
	"""
	detect hits by hitbox components
	"""
	if not area is HitboxComponent:
		return

	print_debug("HurtboxComponent: hit by " + area.name)
	health_component.take_damage((area as HitboxComponent).damage)

# ========
# class functions
# ========
