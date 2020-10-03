extends Node

var fsm: StateMachine

var navigator
var speed
var mover
var navPath
var positionNode
var target = null

func _init(_positionNode, _mover, _speed, _navigator):
	positionNode = _positionNode
	mover = _mover
	speed = _speed
	navigator = _navigator

func enter():
	navPath = navigator.get_simple_path(positionNode.global_position, target.global_position)
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if target != null:
		navPath = navigator.get_simple_path(positionNode.global_position, target.global_position)
		positionNode.look_at(target.global_position)
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		var distanceToTarget = positionNode.global_position.distance_to(target.global_position)
		if distanceToTarget < 30:
			fsm.get_node("Attacking").target = target
			exit("Attacking")
	elif navPath.size() > 0:
		get_parent().get_parent().look_at(navPath[0])
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() <= 0:
			exit("Investigating")
	else:
		fsm.back()
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]

func handleTargetDetected(_target):
	target = _target
