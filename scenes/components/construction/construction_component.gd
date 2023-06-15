extends Node2D
class_name ConstructionComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal construction_completed

# ========
# class onready vars
# ========

@onready var timer: Timer = $%Timer
@onready var progress_bar: ProgressBar = $%ProgressBar

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(_delta: float) -> void:
	if timer.is_stopped():
		return

	progress_bar.value = 1 - (timer.time_left / timer.wait_time)

# ========
# signal handler
# ========

func _on_timer_timeout() -> void:
	"""hide and emit signal"""
	hide()
	construction_completed.emit()

# ========
# class functions
# ========

func set_timer(time: float) -> void:
	timer.set_wait_time(time)

func start_timer() -> void:
	timer.start()
