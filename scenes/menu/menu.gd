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
	self.on_show()
	return self

func hide_menu() -> void:
	"""hide the current menu"""
	self.on_hide()
	self.hide()

func on_hide() -> void:
	""" virtual function to extend with additional steps when a menu is hidden """
	pass

func on_show() -> void:
	""" virtual function to extend with additional steps when a menu is displayed """
	pass