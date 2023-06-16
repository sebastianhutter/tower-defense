extends Area2D
class_name Ufo

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
@onready var hitbox_component: HitboxComponent = $%HitboxComponent
@onready var movement_component: MovementComponent = $%MovementComponent
@onready var navigation_component: NavigationComponent = $%NavigationComponent
@onready var health_component: HealthComponent = $%HealthComponent

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

