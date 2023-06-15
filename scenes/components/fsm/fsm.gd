# thanks to: https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

extends Node
class_name FSM

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal transitioned_to(state_name)

# ========
# class onready vars
# ========

# ========
# class vars
# ========

var body: Character = null
var last_state: FSMState = null
var current_state: FSMState = null

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():
	# wait for owner to be ready before initializing the state machine
	await owner.ready
	
	# initialize fsm signals etc
	initialize()

	# initialize variables to pass along
	body = owner as Character
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
		if child is FSMState:
			child.fsm = self
			child.initialize()

func set_initial_state() -> void:
	"""set the initial state of the state machine"""
	
	if current_state == null:
		for i in range(get_child_count()):
			var child = get_child(i)
			if child is FSMState:
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
	transitioned_to.emit(current_state.name)
