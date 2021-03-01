extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()

func enter():
	eldestParent.get_node("AnimatedSprite").play("Idle_Transition")
	return

func exit(next_state):
	fsm.change_to(next_state)
	return next_state

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if eldestParent.velocity and Input.is_action_pressed("run"):
		exit("Running")
	elif eldestParent.velocity:
		exit("Walking")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
