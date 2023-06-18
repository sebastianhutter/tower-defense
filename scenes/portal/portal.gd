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

var portal_open: bool = false
var send_wave_requested: bool = false

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
	if portal_open:
		return

	portal_open = true
	animation_player.play("portal")

func _on_wave_incoming(time_to_wave: float, current_wave: int, next_wave: int, wave_count: int) -> void:
	""" setup an internal timer to end shortly before the wave arrives """

	if send_wave_requested:
		return 

	if not timer:
		print_debug("no timer node found")
		return
	timer.start(time_to_wave - 0.55)

func _on_send_wave() -> void:
	""" if the player requests the first wave immediately there is no way of waiting """

	send_wave_requested = true

	timer.start(0.1)


# ========
# class functions
# ========
