# thanks to: 
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

extends Node
class_name UfoStateMachineState

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

var ufo: Ufo = null
var fsm: UfoStateMachine = null

# ========
# godot functions
# ========

func _ready() -> void:
	await owner.ready

# ========
# signal handler
# ========

# ========
# class functions
# ========


func initialize() -> void:
	"""sets additional variables etc after the node has been instanced and the fsm component is ready"""
	pass

func handle_input(_event: InputEvent) -> void:
	"""Virtual function. Receives events from the `_unhandled_input()` callback."""
	pass
 
func update(_delta: float) -> void:
	"""Virtual function. Corresponds to the `_process()` callback."""
	pass
 
func physics_update(_delta: float) -> void:
	"""Virtual function. Corresponds to the `_physics_process()` callback."""
	pass

func enter(_msg := {}) -> void:
	"""
	Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
	is a dictionary with arbitrary data the state can use to initialize itself.
	"""
	pass

func exit() -> void:
	"""
	Virtual function. Called by the state machine before changing the active state. Use this function
	to clean up the state.
	"""
	pass

