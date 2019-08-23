extends Node

export(float) var rotationSpeed
export(NodePath) var targetNodePath
var targetRotation
var nodeToRotate

const DEGREES_IN_CIRCLE = 360

func _ready():
	var nodeToRotate = get_node(targetNodePath)

func _physics_process(delta):
	if nodeToRotate == null:
		nodeToRotate = get_parent()
	var currentRotation = nodeToRotate.rotation_degrees
	
	if targetRotation != null:
		rotateToAngle(delta, targetRotation, getShouldRotateClockwise(currentRotation))

func getShouldRotateClockwise(currentRotation):
	var clockwiseAngle = 0
	var antiClockwiseAngle = 0
	if currentRotation > targetRotation:
		clockwiseAngle = DEGREES_IN_CIRCLE - currentRotation + targetRotation
		antiClockwiseAngle = currentRotation - targetRotation
	else:
		clockwiseAngle = targetRotation - currentRotation
		antiClockwiseAngle = DEGREES_IN_CIRCLE - targetRotation + currentRotation
	return not(clockwiseAngle > antiClockwiseAngle)

func rotateToAngle(delta, rotationTarget, shouldRotateClockwise):
	var parentAngle = get_parent().rotation_degrees
	var angleToRotate = rotationSpeed * delta
	
	parentAngle = updateCurrentRotation(parentAngle, angleToRotate, shouldRotateClockwise)
	
	if abs(parentAngle + angleToRotate - rotationTarget) - 5 < angleToRotate:
		targetRotation = null
		
	get_parent().rotation_degrees = parentAngle
	
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
