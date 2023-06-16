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
	pass

func handle_input(_event: InputEvent):
	pass
 
func update(_delta):
	pass
 
func physics_update(_delta):
	""" if ideling lets stop moving """
	
	if fsm.movement_component:
		fsm.movement_component.move(fsm.body, Vector2.ZERO)

func enter(_msg = {}):
	pass

func exit():
	pass

