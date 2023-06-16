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

func _on_ufo_hit_player_hq() -> void:

	fsm.transition_to(UfoStateMachine.STATE.HIT)


# ========
# class functions
# ========

func physics_update(_delta):

	if not ufo.navigation_component or not ufo.movement_component:
		return

	var next_position: Vector2 = ufo.navigation_component.get_next_path_position()
	ufo.movement_component.move(next_position, _delta)

func enter(_msg = {}):

	if not ufo.navigation_component:
		return

	# the HQ is always at 0/0 + HQ Offset
	ufo.navigation_component.target_position = Vector2.ZERO + Constants.TOWER_HQ_OFFSET

	# if the ufo collides with the hq the signal hit_player_hq is emitted. catch it in here
	# to transfer from move to hit
	ufo.hit_player_hq.connect(_on_ufo_hit_player_hq)

func exit() -> void:
	""" disconnect any events """
	ufo.hit_player_hq.disconnect(_on_ufo_hit_player_hq)
