extends CanvasLayer
class_name ResourceUi

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

@onready var gold_label: Label = $%GoidLabel

# ========
# class vars
# ========

# ========
# godot functions
# ========


# ========
# signal handler
# ========

func resource_gold_amount_changed(old_amount: int, new_amount: int):
	""" set the label to the new amount, the event is forwaed by the HUD scene! """

	# TODO: add some lerping to count down or up the amount... just to make it look more fancy
	gold_label.text = str(new_amount)

# ========
# class functions
# ========

