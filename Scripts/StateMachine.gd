extends Node

class_name StateMachine

const DEBUG = true

var state: Object

var history = []

func _ready():
	pass
	
func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()
	
func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()
		
func _enter_state():
	if DEBUG:
		print("Entering state: ", state.name)
	# Give the new state a reference to this state machine script
	state.fsm = self
	state.enter()

func physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)
