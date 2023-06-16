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

@onready var hurtbox_component: HurtboxComponent = $%HurtboxComponent
@onready var health_component: HealthComponent = $%HealthComponent

# ========
# class vars
# ========

# ========
# godot functions
# ========

# func _ready():
# 	health_component.died.connect(_on_health_component_died)


# ========
# signal handler
# ========

func _on_health_component_died() -> void:

	print('AAAAAAAAAAAAAAAAAAAA')
	tower_destroyed.emit(self)

func _on_hurtbox_boxy_entered(body: Node2D) -> void:

	print(body)

# ========
# class functions
# ========

func _tower_ready() -> void:
	""" setup health component """

	print('weiorgnioergnioerngioerniogneoigneiorgnioerngioperngiopenriopgneruiopgneuiropgnuiopergnuiperbnguerbnguebnuipgrnbiuerngioerngioperngiopneriognioergnioerngioerngiongioerngioernio')
	if health_component:
		health_component.died.connect(_on_health_component_died)

	if hurtbox_component:
		hurtbox_component.body_entered.connect(_on_hurtbox_boxy_entered)