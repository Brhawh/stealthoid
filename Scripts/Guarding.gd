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
onready var target = get_parent().get_parent().target
onready var mover = get_node("../../Mover")
onready var eldestParent = get_parent().get_parent()

const DEGREES_IN_CIRCLE = 360

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
	var positionsInRange = positionsWithinRange(eldestParent.position, guardLocation, 5.0)
	if positionsInRange:
		rotateToNext(delta)
	else:
		navPath = navigator.get_simple_path(eldestParent.global_position, guardLocation)
		navPath = mover.moveAlongPath(delta, speed, navPath, eldestParent)
		if navPath.size() > 0:
			eldestParent.look_at(navPath[0])
		
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
	var currentRotation = eldestParent.rotation_degrees
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
	var parentAngle = eldestParent.rotation_degrees
	var angleToRotate = rotationSpeed * delta
	
	parentAngle = updateCurrentRotation(parentAngle, angleToRotate, getShouldRotateClockwise())
	
	if abs(parentAngle + angleToRotate - rotationDegrees[targetRotationDegrees]) - 5 < angleToRotate:
		targetNextRotation()
		
	eldestParent.rotation_degrees = parentAngle
	
func updateCurrentRotation(currentRotation, angleToRotate, shouldRotateClockwise):
	if shouldRotateClockwise:
		currentRotation += angleToRotate
		if currentRotation >= DEGREES_IN_CIRCLE:
			currentRotation = fmod(currentRotation, DEGREES_IN_CIRCLE)
	else:
		currentRotation -= angleToRotate
		if currentRotation < 0:
			currentRotation = DEGREES_IN_CIRCLE - fmod(abs(currentRotation), DEGREES_IN_CIRCLE)
	return currentRotation
	
func targetNextRotation():
	targetRotationDegrees = targetRotationDegrees + 1
	if targetRotationDegrees > rotationDegrees.size() - 1:
		targetRotationDegrees = 0
		exit("Patrolling")
		
func positionsWithinRange(pos1, pos2, acceptableRange):
	return (abs(pos1.x - pos2.x) < acceptableRange && abs(pos1.y - pos2.y) < acceptableRange)


func _on_Enemy_targetChanged():
	target = get_parent().get_parent().target
