extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()

func enter():
	eldestParent.stopRunning()
	eldestParent.get_node("SoundEmitter").setWalkingRadius()
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if Input.is_action_pressed("run"):
		exit("Running")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
