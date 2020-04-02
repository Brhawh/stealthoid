extends Node

var fsm: StateMachine

var rotationDegrees
var targetRotationDegrees = 0
var rotationSpeed = 50
var guardLocation

const DEGREES_IN_CIRCLE = 360

func enter():
	print("Rotation Degrees: ", rotationDegrees)
	print("Hello from Guarding State!")
	yield(get_tree().create_timer(2.0), "timeout")

func exit(next_state):
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
		moveTowardsGuardLocation(delta)
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
	
func moveTowardsGuardLocation(delta):
	var moveDistance = get_node("../Patrolling").speed * delta
	var startPoint = get_parent().get_parent().position
	var distToNext = startPoint.distance_to(guardLocation)
	if moveDistance <= distToNext and moveDistance > 0.0:
		get_parent().get_parent().position = startPoint.linear_interpolate(guardLocation, moveDistance / distToNext)
	elif moveDistance > distToNext:
		get_parent().get_parent().position = guardLocation