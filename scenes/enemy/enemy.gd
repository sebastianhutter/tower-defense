extends CharacterBody2D
class_name Enemy

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

@onready var state_machine: FSM = $%EnemyFSM
@onready var health_component: HealthComponent = $%HealthComponent
@onready var hurtbox_component: HurtboxComponent =$%HurtboxComponent

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:
	if health_component:
		health_component.died.connect(_on_health_component_died)
	if hurtbox_component:
		hurtbox_component.area_entered.connect(_on_hurtbox_area_entered)

# ========
# signal handler
# ========

func _on_health_component_died() -> void:
	state_machine.transition_to("Die")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	""" if a projectile hits the enemy, tell it to increase the hit count ... i havent found a neater way for a bidirectional hitbox without adding more components... """

	var parent_node: Node2D = area.owner

	if not parent_node is Projectile:
		return


	(parent_node as Projectile).increase_hit_count() 

# ========
# class functions
# ========

func hit_feedback_from_hq() -> void:
	""" function is called when hiting hq """

	state_machine.transition_to("Hit")
