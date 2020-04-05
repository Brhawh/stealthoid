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
var target

const DEGREES_IN_CIRCLE = 360

func enter():
	return

func exit(next_state):
	target = null
	navPath = null
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	var positionsInRange = positionsWithinRange(get_parent().get_parent().position, guardLocation, 5.0)
	if positionsInRange:
		rotateToNext(delta)
	else:
		navPath = navigator.get_simple_path(get_parent().get_parent().global_position, guardLocation)
		moveAlongPath(delta)
		get_parent().get_parent().look_at(navPath[0])
		
	if target != null:
		detector.target = target
		var hitPos = detector.detect_target()
		if !hitPos.empty() && target.lightLevel > 0:
			get_node("../Chasing").target = target
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
	var currentRotation = get_parent().get_parent().rotation_degrees
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
	var parentAngle = get_parent().get_parent().rotation_degrees
	var angleToRotate = rotationSpeed * delta
	
	parentAngle = updateCurrentRotation(parentAngle, angleToRotate, getShouldRotateClockwise())
	
	if abs(parentAngle + angleToRotate - rotationDegrees[targetRotationDegrees]) - 5 < angleToRotate:
		targetNextRotation()
		
	get_parent().get_parent().rotation_degrees = parentAngle
	
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
	
func moveAlongPath(delta):
	var moveDistance = speed * delta
	var startPoint = get_parent().get_parent().position
	# The reason for using a for loop here is so that if the first navPath point is the same position as the
	# enemy's position then it will remove that one and try the next one instead until it finds a position that
	# actually requires it to move. Otherwise the enemy doesn't move when it spots the player.
	for i in navPath.size():
		var distToNext = startPoint.distance_to(navPath[0])
		if moveDistance <= distToNext and moveDistance >- 0.0:
			get_parent().get_parent().position = startPoint.linear_interpolate(navPath[0], moveDistance / distToNext)
			break
		elif distToNext <= 5.0:
			get_parent().get_parent().position = navPath[0]
		moveDistance -= distToNext
		startPoint = navPath[0]
		navPath.remove(0)