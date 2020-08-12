extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()
onready var soundEmitter = get_node("../../SoundEmitter")

func enter():
	eldestParent.setToRunningSpeed()
	soundEmitter.setRunningState()
	soundEmitter.startEmittingSound()
	return

func exit(next_state):
	soundEmitter.stopEmittingSound()
	fsm.change_to(next_state)
	return next_state

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if eldestParent.velocity and Input.is_action_just_released("run"):
		exit("Walking")
	elif !eldestParent.velocity:
		exit("Idle")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
