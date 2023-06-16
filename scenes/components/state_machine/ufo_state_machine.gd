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


var current_state: UfoStateMachineState = null
var current_state_id: STATE
var last_state_id: STATE = STATE.MOVE

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

	# pass parent components for easier use
	pass_components_to_state()
	
	# transition to first state
	transition_to(last_state_id)

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

func _on_health_component_died() -> void:
	transition_to(STATE.DIE)

# ========
# class functions
# ========

enum STATE {
	MOVE = 0,
	HIT,
	DIE,
}

func initialize() -> void:
	""" ensure the 'die' state can be reached in any case """

	if ufo.health_component:
		ufo.health_component.died.connect(_on_health_component_died)


func pass_components_to_state() -> void:
	"""pass the fsm to the state"""
	
	for child in get_children():
		if child is UfoStateMachineState:
			child.fsm = self
			child.ufo = ufo
			child.initialize()

func transition_to_last_state(msg: Dictionary = {}) -> void:
	"""transition to the last state"""

	print_debug("transitioning to last state " + str(last_state_id) + ")")
	transition_to(last_state_id, msg)

func transition_to(state_id: STATE, msg: Dictionary = {}) -> void:
	"""transition between states """

	
	var next_state = get_child(state_id)
	if not next_state:
		print_debug("unable to find state with id " + str(state_id))
		return
	
	print_debug("transitioning to " + str(state_id))
	if current_state:
		current_state.exit()

	if current_state_id:
		(get_child(current_state_id) as UfoStateMachineState).exit()
		last_state_id = current_state_id

	current_state_id = state_id
	current_state = next_state
	current_state.enter(msg)


