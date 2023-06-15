extends Menu
class_name GameOverWinMenu

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

signal replay_button_pressed
signal quit_to_menu_button_pressed

# ========
# class onready vars
# ========

@onready var replay_button: Button = $%ReplayButton
@onready var quit_to_menu_button: Button = $%QuitToMenuButton

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	replay_button.pressed.connect(_on_replay_button_pressed)
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)

# ========
# signal handler
# ========

func _on_replay_button_pressed() -> void:
	"""emit the play pressed signal"""
	replay_button_pressed.emit()

func _on_quit_to_menu_button_pressed() -> void:
	"""emit the quit pressed signal"""
	quit_to_menu_button_pressed.emit()

# ========
# class functions
# ========
