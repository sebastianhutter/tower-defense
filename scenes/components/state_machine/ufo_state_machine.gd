# thanks to: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
# and https://docs.godotengine.org/en/3.2/tutorials/misc/state_design_pattern.html
extends Node
class_name UfoStateMachineUfo

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
var last_state: UfoStateMachineState = null
var current_state: UfoStateMachineState = null

# ========
# godot functions
# ========

func _ready():
	# wait for owner to be ready before initializing the state machine
	await owner.ready
	
	# set ownership of fsm
	ufo = owner as Ufo

	# initialize fsm signals etc
	initialize()

	pass_components_to_state()
	set_initial_state()

# pass the loop executions to the current state
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


# ========
# signal handler
# ========

# ========
# class functions
# ========


func initialize() -> void:
	"""virtual function to initialize child fsms"""
	pass

func pass_components_to_state() -> void:
	"""pass the fsm to the state"""
	
	for child in get_children():
		if child is UfoStateMachineState:
			child.fsm = self
			child.ufo = ufo
			child.initialize()

func set_initial_state() -> void:
	"""set the initial state of the state machine"""
	
	if current_state == null:
		for i in range(get_child_count()):
			var child = get_child(i)
			if child is UfoStateMachineState:
				transition_to(child.name)
				break

func transition_to_last_state(msg: Dictionary = {}) -> void:
	"""transition to the last state"""

	print_debug("transitioning to last state")
	transition_to(last_state.name, msg)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	"""transition between states """
	if not has_node(target_state_name):
		return

	print_debug("transitioning to " + target_state_name)
	if current_state:
		current_state.exit()
		last_state = current_state
	
	current_state = get_node(target_state_name)
	current_state.enter(msg)

