extends CanvasLayer
class_name Menu

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

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func show_menu() -> Menu:
	"""show the current menu"""
	self.show()
	return self

func hide_menu() -> void:
	"""hide the current menu"""
	self.hide()
