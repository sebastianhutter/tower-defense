extends AudioStreamPlayer
class_name GameMusicPlayer
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

@onready var timer: Timer = $%Timer


# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(_on_finished)
	if timer:
		timer.timeout.connect(_on_timeout)

	play()

# ========
# signal handler
# ========

func _on_finished() -> void:
	if timer:
		timer.start()

func _on_timeout() -> void:
	play()

# ========
# class functions
# ========

