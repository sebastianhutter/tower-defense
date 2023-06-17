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
signal decrease_wave_count(wave_id: int)

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

# the wave the ufo belongs too
var wave_id: int = -1

# ========
# godot functions
# ========

func _ready():
	if hurtbox_component:
		hurtbox_component.area_entered.connect(_on_hurtbox_area_entered)

func _exit_tree():
	""" when the object is removed from the scene ensure the enemy manager can remove it from the wave counter """

	# running this in _exit_tree and not in die or hit fsm ensures that the
	# win condition can be achieved even if the object is removed due to some uunforseen reason!
	decrease_wave_count.emit(wave_id)

# ========
# signal handler
# ========

func _on_hurtbox_area_entered(area: Area2D) -> void:
	""" if a projectile hits the enemy, tell it to increase the hit count ... i havent found a neater way for a bidirectional hitbox without adding more components... """

	var parent_node: Node2D = area.owner
	if not parent_node is Projectile:
		return

	(parent_node as Projectile).hit_count += 1


# ========
# class functions
# ========

func hit_feedback_from_hq() -> void:
	""" workaround for missing bi-directional area2d entered support """

	# this function is called by the players hq while the two objects are colliding
	# this allows the ufo itself to handle what happens with the collision
	# but it's kinda hacky

	hit_player_hq.emit()
