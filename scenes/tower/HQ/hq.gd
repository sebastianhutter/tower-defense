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

signal hq_hit(health_left)

# ========
# class onready vars
# ========

@onready var hurtbox_component: HurtboxComponent = $%HurtboxComponent
@onready var health_component: HealthComponent = $%HealthComponent
@onready var health_bar: ProgressBar = $%HealthProgressBar

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

func _on_health_component_died() -> void:
	tower_destroyed.emit(self)

func _on_health_changed() -> void:
	if health_bar:
		health_bar.value = health_component.get_health_percent()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	""" we send the enemy that hit the hq the hit signal so it goes puff """

	# this could also be achieved by sending a game event
	# the enemy listening on the game event with its area2d id
	# and reacting on it but this seems like a lot of overhead
	
	var parent_node = area.owner
	if not parent_node is Ufo:
		return

	if parent_node.has_method("hit_feedback_from_hq"):
		parent_node.hit_feedback_from_hq()

	# emit hq hit so tower manager can push the event to game events
	hq_hit.emit(health_component.get_health_percent())

# ========
# class functions
# ========

func _tower_ready() -> void:
	""" setup health component """

	if health_component:
		health_component.died.connect(_on_health_component_died)
		health_component.health_changed.connect(_on_health_changed)

	if hurtbox_component:
		hurtbox_component.area_entered.connect(_on_hurtbox_area_entered)
