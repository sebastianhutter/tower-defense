extends Menu
class_name GameMainMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal play_button_pressed
signal options_button_pressed
signal quit_button_pressed

# ========
# class onready vars
# ========

@onready var play_button: Button = $%PlayButton
@onready var options_button: Button = $%OptionsButton
@onready var quit_button: Button = $%QuitButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

# ========
# signal handler
# ========

func _on_play_button_pressed() -> void:
	"""emit the play pressed signal"""
	play_button_pressed.emit()

func _on_options_button_pressed() -> void:
	"""emit the quit pressed signal"""
	options_button_pressed.emit()

func _on_quit_button_pressed() -> void:
	"""emit the quit pressed signal"""
	quit_button_pressed.emit()

# ========
# class functions
# ========
