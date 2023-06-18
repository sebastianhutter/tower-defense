extends Button
class_name SoundButton

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

@onready var audio_stream_player: AudioStreamPlayer = $%AudioStreamPlayer

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:


	if audio_stream_player:
		pressed.connect(_on_pressed)

# ========
# signal handler
# ========

func _on_pressed() -> void:
	""" play a click sound everytime the button is pressed """

	audio_stream_player.play()

# ========
# class functions
# ========
