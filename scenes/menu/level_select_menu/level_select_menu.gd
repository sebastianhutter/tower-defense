
extends Menu
class_name GameLevelSelectMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal enter_tower_button_pressed
signal back_button_pressed

# ========
# class onready vars
# ========

@onready var enter_tower_button: Button = $%EnterTower
@onready var back_button: Button = $%BackButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	enter_tower_button.pressed.connect(_on_enter_tower_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

# ========
# signal handler
# ========

func _on_enter_tower_button_pressed() -> void:
	"""emit the level select pressed signal"""
	enter_tower_button_pressed.emit()

func _on_back_button_pressed() -> void:
	"""emit the quit pressed signal"""
	back_button_pressed.emit()

# ========
# class functions
# ========
