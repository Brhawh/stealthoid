extends Node

var fsm: StateMachine

onready var eldestParent = get_parent().get_parent()

func enter():
	return

func exit(next_state):
	fsm.change_to(next_state)
	return next_state

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if eldestParent.direction == 1:
		eldestParent.get_node("AnimatedSprite").play("IdleBack")
	elif eldestParent.direction == 2:
		eldestParent.get_node("AnimatedSprite").play("IdleBack")
	elif eldestParent.direction == 3:
		eldestParent.get_node("AnimatedSprite").play("IdleBack")
	elif eldestParent.direction == 4:
		eldestParent.get_node("AnimatedSprite").play("IdleLeft")
	elif eldestParent.direction == 5:
		eldestParent.get_node("AnimatedSprite").play("IdleRight")
	elif eldestParent.direction == 6 && eldestParent.torchOn == false:
		eldestParent.get_node("AnimatedSprite").play("IdleFront")
	elif eldestParent.direction == 7 && eldestParent.torchOn == false:
		eldestParent.get_node("AnimatedSprite").play("IdleFront")
	elif eldestParent.direction == 8 && eldestParent.torchOn == false:
		eldestParent.get_node("AnimatedSprite").play("IdleFront")
	elif eldestParent.direction == 6 && eldestParent.torchOn == true:
		eldestParent.get_node("AnimatedSprite").play("IdleFrontTorch")
	elif eldestParent.direction == 7 && eldestParent.torchOn == true:
		eldestParent.get_node("AnimatedSprite").play("IdleFrontTorch")
	elif eldestParent.direction == 8 && eldestParent.torchOn == true:
		eldestParent.get_node("AnimatedSprite").play("IdleFrontTorch")
	
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
