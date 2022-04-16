extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()

func enter():
	eldestParent.setToWalkingSpeed()
	return

func exit(next_state):
	fsm.change_to(next_state)
	return next_state

func process(delta):
	return delta

func physics_process(delta):
	if eldestParent.direction == 4:
		eldestParent.get_node("AnimatedSprite").play("WalkBack")
	elif eldestParent.direction == 3:
		eldestParent.get_node("AnimatedSprite").play("WalkLeft")
	elif eldestParent.direction == 1:
		eldestParent.get_node("AnimatedSprite").play("WalkRight")
	elif eldestParent.direction == 2:
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
