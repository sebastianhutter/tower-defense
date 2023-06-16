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
