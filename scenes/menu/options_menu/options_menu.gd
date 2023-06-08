extends Menu
class_name GameOptionsMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal back_button_pressed

# ========
# class onready vars
# ========

@onready var back_button: Button = $%BackButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	back_button.pressed.connect(_on_back_button_pressed)

# ========
# signal handler
# ========

func _on_back_button_pressed() -> void:
	"""emit the play pressed signal"""
	back_button_pressed.emit()

# ========
# class functions
# ========
