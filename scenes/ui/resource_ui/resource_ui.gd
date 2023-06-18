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
@onready var gold_icon: TextureRect = $%GoldIcon
@onready var floating_text_scene: PackedScene = preload(Constants.SCENE_FLOATING_TEXT)
@onready var gold_sound: AudioStreamPlayer = $%GoldSound

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
	gold_label.text = str(new_amount)

	# show floating text and play sfx for gold resource changes
	if old_amount == new_amount or (new_amount - old_amount) > 1000:
		# dont display a floating text if a no change event was emitted
		# also dont display to high numbers, this shouldnt happen - we dont
		# add numbers together before printing the value
		return

	show_floating_text(str(new_amount - old_amount))
	play_gold_sound()
# ========
# class functions
# ========

func show_floating_text(text: String) -> void:
	""" show a floating text animation for gold resource changes """

	var floating_text: Node2D = floating_text_scene.instantiate() as Node2D
	# position the floating text a little below the gold icon and shifted to the left
	floating_text.global_position = gold_icon.global_position + Vector2(-5, 40)
	add_child(floating_text)
	floating_text.start(text)

func play_gold_sound() -> void:
	""" play gold sound if resource changes """

	if gold_sound:
		if gold_sound.playing:
			return

		gold_sound.play()
