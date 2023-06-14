extends Character

# ========
# singleton references
# ========

# ========
# export vars
# ========


# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

@onready var state_machine: FSM = $%EnemyFSM
@onready var health_component: HealthComponent = $%HealthComponent
@onready var tower_collision_component: TowerCollisionComponent = $%TowerCollisionComponent

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:
	health_component.died.connect(_on_health_component_died)
	tower_collision_component.tower_collided.connect(_on_tower_collision_component_tower_collided)

# ========
# signal handler
# ========

func _on_health_component_died() -> void:
	state_machine.transition_to("Died")

func _on_tower_collision_component_tower_collided(tower: Tower) -> void:
	
	print(tower)

	if not tower is HQ:
		return

	state_machine.transition_to("Hit")

# ========
# class functions
# ========

