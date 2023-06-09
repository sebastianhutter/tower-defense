extends FSM
class_name FSMEnemy

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var navigation_component: NavigationComponent
@export var movement_component: MovementComponent
#@export var senses_component: SensesComponent

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

#func _on_body_entered_hearing_range(_body: Node3D) -> void:
#	"""if a body enters the hearing range try to detect it"""
#	if current_state.name in ["Patrol"]:
#		transition_to("Detect", {"position": _body.global_position})
#
#func _on_body_exited_hearing_range(_body: Node3D):
#	"""if the body has left the hearing range"""
#	# revert to the last state if the current state is either 
#	# waiting, detecting or patrolling
#	if current_state.name in ["Detect"]:
#		transition_to("Patrol")
#
#func _on_body_entered_sight_range(_body: Node3D) -> void:
#	"""if a body enters the sight range immediately start chasing it"""
#	if current_state.name in ["Patrol", "Detect"]:
#		# reset any potential chase reset timer
#		if chase_timer:
#			chase_timer.stop()
#		transition_to("Chase", {"target": _body})
#
#func _on_body_exited_sight_range(_body: Node3D):
#	"""if the body has left the sight range switch to patrolling"""
#	# revert to the last state if the current state is either 
#	# waiting, detecting or patrolling
#	if current_state.name in ["Chase"]:
#		# if the agent looses eyesight of the agent it still chases it for another few seconds
#		# before giving up and returning to patrol. to do this the cahsetimer is activated and 
#		# when it timesout we switch back to patrol
#		if chase_timer:
#			if chase_timer.is_stopped():
#				chase_timer.start()
#
#func _on_chase_timer_timeout():
#	"""if the chase timer times out switch back to patrol"""
#	transition_to("Patrol")

# signal handlers of the navigation agent
# registered on top level fsm as depending on the current state
# the navigation agent is either active or not



func _on_navigation_component_navigation_finished():
	
	if current_state.name == "Walk":
		transition_to("Idle")
	



# ========
# class functions
# ========

func initialize():
	# set up signals

	if navigation_component:
		navigation_component.navigation_finished.connect(_on_navigation_component_navigation_finished)


#	if senses_component:
#		senses_component.body_entered_sight_range.connect(_on_body_entered_sight_range)
#		senses_component.body_exited_sight_range.connect(_on_body_exited_sight_range)
#		senses_component.body_entered_hearing_range.connect(_on_body_entered_hearing_range)
#		senses_component.body_exited_hearing_range.connect(_on_body_exited_hearing_range)

	
	# connect chase timer with signal to handle transition from chase lost to patrol
	# i decided to handle this transition in the main fsm to keep the chase code simple
	# e.g. no need to duplicate the code for chasing in a potential additional state for "target lost"
#	if has_node("Chase"):
#		chase_timer = get_node("Chase").chase_timer
#
#	if chase_timer:
#		chase_timer.timeout.connect(_on_chase_timer_timeout)
