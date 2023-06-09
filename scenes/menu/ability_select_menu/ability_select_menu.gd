
extends Menu
class_name GameAbilitySelectMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal level_select_button_pressed
signal back_button_pressed

# ========
# class onready vars
# ========

@onready var level_select_button: Button = $%LevelSelectButton
@onready var back_button: Button = $%BackButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	level_select_button.pressed.connect(_on_level_select_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

# ========
# signal handler
# ========

func _on_level_select_button_pressed() -> void:
	"""emit the level select pressed signal"""
	level_select_button_pressed.emit()

func _on_back_button_pressed() -> void:
	"""emit the quit pressed signal"""
	back_button_pressed.emit()

# ========
# class functions
# ========

