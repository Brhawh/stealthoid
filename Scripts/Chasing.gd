extends Node

var fsm: StateMachine

var navigator
var detector
var speed
var target: KinematicBody2D
var mover
var navPath
var positionNode

func _init(_positionNode, _mover, _target, _speed, _detector, _navigator):
	positionNode = _positionNode
	mover = _mover
	target = _target
	speed = _speed
	detector = _detector
	navigator = _navigator
	

func enter():
	navPath = navigator.get_simple_path(positionNode.global_position, target.global_position)
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if navPath.size() > 0:
		get_parent().get_parent().look_at(navPath[0])
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
	if target != null:
		var hitPos = detector.detect_target(target)
		if !hitPos.empty() && target.lightLevel > 0:
			navPath = navigator.get_simple_path(positionNode.global_position, target.global_position)
			positionNode.look_at(target.position)
			var distanceToTarget = positionNode.global_position.distance_to(target.global_position)
			if distanceToTarget < 30:
				exit("Attacking")
		else:
			if navPath.size() <= 0:
				fsm.back()
	else:
		exit("Investigating")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
	
#func moveAlongPath(delta):
#	var moveDistance = speed * delta
#	var startPoint = get_parent().get_parent().position
#	# The reason for using a for loop here is so that if the first navPath point is the same position as the
#	# enemy's position then it will remove that one and try the next one instead until it finds a position that
#	# actually requires it to move. Otherwise the enemy doesn't move when it spots the player.
#	for i in navPath.size():
#		var distToNext = startPoint.distance_to(navPath[0])
#		if moveDistance <= distToNext and moveDistance >- 0.0:
#			get_parent().get_parent().position = startPoint.linear_interpolate(navPath[0], moveDistance / distToNext)
#			break
#		elif distToNext <= 5.0:
#			get_parent().get_parent().position = navPath[0]
#		moveDistance -= distToNext
#		startPoint = navPath[0]
#		navPath.remove(0)


func _on_Enemy_targetChanged():
	target = positionNode.target
