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


# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:
	health_component.died.connect(_on_health_component_died)


# ========
# signal handler
# ========

func _on_health_component_died() -> void:
	state_machine.transition_to("Died")


# ========
# class functions
# ========

