extends Node2D
class_name Portal

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

@onready var sprite: Sprite2D = $%Sprite
@onready var timer: Timer = $%Timer
@onready var animation_player: AnimationPlayer = $%AnimationPlayer

# ========
# class vars
# ========

# ========
# godot functions
# ========


func _ready():
	
	if sprite:
		sprite.hide()

	if timer:
		timer.timeout.connect(_on_timer_timeout)

# ========
# signal handler
# ========

func _on_timer_timeout():
	animation_player.play("portal")

func _on_wave_incoming(time_to_wave: float, current_wave: int, next_wave: int, wave_count: int) -> void:
	""" setup an internal timer to end shortly before the wave arrives """

	if not timer:
		print_debug("no timer node found")
		return

	timer.wait_time = time_to_wave - 0.55 # the animation time of the open animation is ~ 0.5s
	timer.start()


# ========
# class functions
# ========
