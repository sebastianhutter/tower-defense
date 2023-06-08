extends Menu
class_name GamePauseMenu

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

signal continue_button_pressed
signal options_button_pressed
signal quit_to_menu_button_pressed

# ========
# class onready vars
# ========

@onready var continue_button: Button = $%ContinueButton
@onready var options_button: Button = $%OptionsButton
@onready var quit_to_menu_button: Button = $%QuitToMenuButton

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.pressed.connect(_on_continue_button_pressed)
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)

# ========
# signal handler
# ========

func _on_continue_button_pressed() -> void:
	"""emit the play pressed signal"""
	continue_button_pressed.emit()

func _on_quit_to_menu_button_pressed() -> void:
	"""emit the quit pressed signal"""
	quit_to_menu_button_pressed.emit()

func _on_options_button_pressed() -> void:
	"""emit the options pressed signal"""
	options_button_pressed.emit()

# ========
# class functions
# ========
