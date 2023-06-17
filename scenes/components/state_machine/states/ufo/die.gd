extends UfoStateMachineState

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

func enter(_msg = {}):
	if ufo.animation_player:
		if ufo.animation_player.has_animation("Die"):
			ufo.animation_player.play("Die")
			await ufo.animation_player.animation_finished

	ufo.queue_free()