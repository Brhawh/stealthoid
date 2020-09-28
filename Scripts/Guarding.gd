extends Node

var fsm: StateMachine

var rotationDegrees
var targetRotationDegrees = 0
var rotationSpeed = 40
var guardLocation
var navigator
var navPath
var speed
var paused
onready var mover
onready var positionNode

var _timer

const DEGREES_IN_CIRCLE = 360

func _init(_navigator, _positionNode, _mover, _speed, _guardLocation, _rotationDegrees):
	navigator = _navigator
	positionNode = _positionNode
	mover = _mover
	speed = _speed
	guardLocation = _guardLocation
	rotationDegrees = _rotationDegrees

func enter():
	return

func exit(next_state):
	paused = false
	navPath = null
	targetRotationDegrees = 0
	fsm.change_to(next_state)

func physics_process(delta):
	var positionsInRange = positionsWithinRange(positionNode.position, guardLocation, 5.0)
	if positionsInRange:
		if !paused:
			rotateToNext(delta)
	else:
		navPath = navigator.get_simple_path(positionNode.global_position, guardLocation)
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() > 0:
			var targetAngle = positionNode.global_position.direction_to(navPath[0]).angle()
			if targetAngle < 0:
				targetAngle = PI * 2 + targetAngle
			positionNode.rotation = lerp(positionNode.rotation, targetAngle, 0.08)
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
	
func rotateToNext(delta):
	positionNode.rotation_degrees = lerp(positionNode.rotation_degrees, rotationDegrees[targetRotationDegrees], 0.08)
	if abs(rotationDegrees[targetRotationDegrees] - positionNode.rotation_degrees) <= 5:
		pause("targetNextRotation")
	return delta
	
func targetNextRotation():
	targetRotationDegrees = targetRotationDegrees + 1
	if targetRotationDegrees > rotationDegrees.size() - 1:
		targetRotationDegrees = 0
		exit("Patrolling")
	paused = false

func positionsWithinRange(pos1, pos2, acceptableRange):
	return (abs(pos1.x - pos2.x) < acceptableRange && abs(pos1.y - pos2.y) < acceptableRange)
	
func pause(timeoutFunc):
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, timeoutFunc)
	_timer.set_wait_time(2)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	paused = true
