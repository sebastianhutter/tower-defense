# thanks to: 
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

extends Node
class_name FSMState

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

# ========
# class signals
# ========

signal request_transition_to_new_state(state_name: String, msg: Dictionary)
signal request_transition_to_last_state(msg: Dictionary)

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var fsm: FSM

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

# func init() -> void:
# 	
# 	pass

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







# #
# # i think i will get rid of the behaviours. to much abstraction for a not so complex game!
# #

# func pass_state_to_behaviour() -> void:
# 	"""
# 	Helper function. Passes the state to all behaviours.
# 	"""

# 	for behaviour in get_children():
# 		if behaviour is FSMBehaviour:
# 			behaviour.state = self

# func get_behaviour(behaviour_name: String) -> FSMBehaviour:
# 	"""
# 	Returns the behaviour with the given name. If the state doesn't have a behaviour with that name,
# 	returns `null`.
# 	"""

# 	for behaviour in get_children():
# 		if behaviour.name == behaviour_name and behaviour is FSMBehaviour:
# 			return behaviour

# 	return null

# func execute_behaviours_in_order(delta: float) -> void:
# 	"""executes all attached behaviour in order"""
# 	for behaviour in get_children():
# 		if behaviour is FSMBehaviour:
# 			behaviour.execute(delta)
