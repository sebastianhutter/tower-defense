extends Node2D
class_name DamageIndiciatorCompopnent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var health_component: HealthComponent
@export_range(0.1, 1.0, 0.1) var show_smoke_when_health_lower: float

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var effect_damage_smoke: GPUParticles2D = $%EffectDamageSmoke


# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	if effect_damage_smoke:
		effect_damage_smoke.hide()

	if health_component:
		health_component.health_changed.connect(_on_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_health_changed() -> void:
	var current_health = health_component.get_health_percent()
	if current_health <= show_smoke_when_health_lower:
		if effect_damage_smoke:
			effect_damage_smoke.show()

# ========
# class functions
# ========

