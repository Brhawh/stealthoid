extends Node

var fsm: StateMachine

var rotationDegrees
var targetRotationDegrees = 0
var rotationSpeed = 40
var guardLocation
var navigator
var navPath
var speed
var detector
onready var target
onready var mover
onready var positionNode

const DEGREES_IN_CIRCLE = 360

func _init(_navigator, _positionNode, _mover, _target, _detector, _speed, _guardLocation, _rotationDegrees):
	navigator = _navigator
	positionNode = _positionNode
	mover = _mover
	target = _target
	detector = _detector
	speed = _speed
	guardLocation = _guardLocation
	rotationDegrees = _rotationDegrees

func enter():
	return

func exit(next_state):
	navPath = null
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	var positionsInRange = positionsWithinRange(positionNode.position, guardLocation, 5.0)
	if positionsInRange:
		rotateToNext(delta)
	else:
		navPath = navigator.get_simple_path(positionNode.global_position, guardLocation)
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() > 0:
			var targetAngle = positionNode.global_position.direction_to(navPath[0]).angle()
			if targetAngle < 0:
				targetAngle = PI * 2 + targetAngle
			positionNode.rotation = lerp(positionNode.rotation, targetAngle, 0.1)
		
	if target != null:
		var hitPos = detector.detect_target(target)
		if !hitPos.empty() && target.lightLevel > 0:
			#get_node("../Chasing").target = target
			exit("Chasing")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
	
func getShouldRotateClockwise():
	var currentRotation = positionNode.rotation_degrees
	var clockwiseAngle = 0
	var antiClockwiseAngle = 0
	if  currentRotation > rotationDegrees[targetRotationDegrees]:
		clockwiseAngle = DEGREES_IN_CIRCLE - currentRotation + rotationDegrees[targetRotationDegrees]
		antiClockwiseAngle = currentRotation - rotationDegrees[targetRotationDegrees]
	else:
		clockwiseAngle = rotationDegrees[targetRotationDegrees] - currentRotation
		antiClockwiseAngle = DEGREES_IN_CIRCLE - rotationDegrees[targetRotationDegrees] + currentRotation
	return not(clockwiseAngle > antiClockwiseAngle)
	
func rotateToNext(delta):
	positionNode.rotation_degrees = lerp(positionNode.rotation_degrees, rotationDegrees[targetRotationDegrees], 0.03)
	if abs(rotationDegrees[targetRotationDegrees] - positionNode.rotation_degrees) <= 5:
		targetNextRotation()
	return delta
	
func targetNextRotation():
	targetRotationDegrees = targetRotationDegrees + 1
	if targetRotationDegrees > rotationDegrees.size() - 1:
		targetRotationDegrees = 0
		exit("Patrolling")
		
func positionsWithinRange(pos1, pos2, acceptableRange):
	return (abs(pos1.x - pos2.x) < acceptableRange && abs(pos1.y - pos2.y) < acceptableRange)

func _on_Enemy_targetChanged():
	target = get_parent().get_parent().target
