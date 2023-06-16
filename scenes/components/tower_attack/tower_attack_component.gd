extends Node
class_name TowerAttackComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

# the upgrade component is used to reference upgrade events and ensure the tower can't attack if it's being upgraded
@export var tower_upgrade_component: TowerUpgradeComponent
@export var range_detector_component: RangeDetectorComponent
@export var attack_controller_component: AttackControllerComponent # TODO: create components for archer, hq and wizard


# ========
# class signals
# ========


# ========
# class onready vars
# ========

@onready var attack_timer: Timer = $%AttackTimer

# ========
# class vars
# ========

var can_attack: bool = true
var damage_modifier: float = 1.0

# ========
# godot functions
# ========

func _ready() -> void:

	# ensure tower can't attack while upgrading
	if tower_upgrade_component:
		tower_upgrade_component.tower_upgrade_started.connect(_on_tower_upgrade_started)
		tower_upgrade_component.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

	if attack_timer:
		attack_timer.timeout.connect(_on_attack_timer_timeout)
		attack_timer.start()


# ========
# signal handler
# ========

func _on_tower_upgrade_started() -> void:
	can_attack = false

	attack_timer.stop()

func _on_tower_upgrade_finished() -> void:
	can_attack = true
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if not can_attack:
		return

	if not attack_controller_component:
		return

	var pos = get_target()
	if pos == Vector2.ZERO:
		return

	attack_controller_component.attack(pos, damage_modifier)


# ========
# class functions
# ========

func set_shot_speed(speed: float) -> void:
	""" sets the attack timer depending on the given shot speed"""

	if not attack_timer:
		print_debug("no atack timer")
		return

	attack_timer.wait_time = speed

func set_shot_damage(damage: float) -> void: 
	""" sets the damage modifier """

	damage_modifier = damage
	
func get_target() -> Vector2:
	""" returns the position of the first enemy in the towers target list. """

	if not range_detector_component:
		return Vector2.ZERO

	var e: CharacterBody2D = range_detector_component.get_first_enemy_in_line()
	if not e:
		return Vector2.ZERO

	return e.global_position

