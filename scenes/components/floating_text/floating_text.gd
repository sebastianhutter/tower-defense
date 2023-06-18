extends Node2D
class_name FloatingText

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

@onready var label: Label = $%Label

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:
	scale = Vector2.ZERO

# ========
# signal handler
# ========

# ========
# class functions
# ========

func start(text: String, font_size: int = 24) -> void:
	""" animate floating text """

	label.text = text
	label.add_theme_font_size_override("font_size", font_size)

	var tween = create_tween()
	tween.set_parallel()

	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.chain()

	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, .4) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.chain()

	tween.tween_callback(queue_free)

	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.5, .15) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_CUBIC)
