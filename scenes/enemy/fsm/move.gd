# thanks to: 
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

extends FSMState

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

func initialize():
	# set target to hq
	fsm.navigation_component.target_position = Vector2.ZERO+Constants.TOWER_HQ_OFFSET


func handle_input(_event: InputEvent):
	pass
 
func update(_delta):
	pass
 
func physics_update(_delta):
	"""walk towards the current target"""
	if not fsm.movement_component or not fsm.navigation_component:
		print_debug("no movement component or navigation component")
		return

	var target_position = fsm.navigation_component.get_next_path_position()
	if target_position == Vector2.ZERO:
		print_debug("no target position")
		return

	var direction = fsm.movement_component.get_movement_direction(fsm.body, target_position)
	fsm.movement_component.move(fsm.body, direction, _delta)


func enter(_msg = {}):
	pass

func exit():
	pass

