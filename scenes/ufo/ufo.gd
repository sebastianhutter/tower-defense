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

signal hit_player_hq()

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

func hit_feedback_from_hq() -> void:
    """ workaround for missing bi-directional area2d entered support """

    # this function is called by the players hq while the two objects are colliding
    # this allows the ufo itself to handle what happens with the collision
    # but it's kinda hacky

    hit_player_hq.emit()