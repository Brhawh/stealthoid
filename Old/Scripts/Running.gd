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
	if eldestParent.direction == 1:
		eldestParent.get_node("AnimatedSprite").play("WalkBack")
	elif eldestParent.direction == 2:
		eldestParent.get_node("AnimatedSprite").play("WalkBack")
	elif eldestParent.direction == 3:
		eldestParent.get_node("AnimatedSprite").play("WalkBack")
	elif eldestParent.direction == 4:
		eldestParent.get_node("AnimatedSprite").play("WalkLeft")
	elif eldestParent.direction == 5:
		eldestParent.get_node("AnimatedSprite").play("WalkRight")
	elif eldestParent.direction == 6:
		eldestParent.get_node("AnimatedSprite").play("WalkFront")
	elif eldestParent.direction == 7:
		eldestParent.get_node("AnimatedSprite").play("WalkFront")
	elif eldestParent.direction == 8:
		eldestParent.get_node("AnimatedSprite").play("WalkFront")
	
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
