extends Tower
class_name HQ

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

@onready var health_component: HealthComponent = $%HealthComponent

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	health_component.died.connect(_on_health_component_died)


# ========
# signal handler
# ========

func _on_health_component_died() -> void:

	tower_destroyed.emit(self)

# ========
# class functions
# ========
