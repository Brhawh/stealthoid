extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()
onready var soundEmitter = get_node("../../SoundEmitter")

func enter():
	eldestParent.setToWalkingSpeed()
	soundEmitter.setWalkingState()
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
	if eldestParent.direction in [1, 2, 3]:
		eldestParent.get_node("AnimatedSprite").play("WalkBack")
	elif eldestParent.direction == 4:
		eldestParent.get_node("AnimatedSprite").play("WalkLeft")
	elif eldestParent.direction == 5:
		eldestParent.get_node("AnimatedSprite").play("WalkRight")
	elif eldestParent.direction in [6, 7, 8]:
		eldestParent.get_node("AnimatedSprite").play("WalkFront")
	
	if Input.is_action_pressed("run"):
		exit("Running")
	if !eldestParent.velocity:
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
