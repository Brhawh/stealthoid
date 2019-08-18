extends Node

export(Array, float) var rotationAngles
export(float) var rotationSpeed
export(bool) var repeat

var currentTargetIndex = 0
var targetAngle

const DEGREES_IN_CIRCLE = 360

func _physics_process(delta):
	var parentAngle = get_parent().rotation_degrees
	
	if currentTargetIndex != -1:
		targetAngle = rotationAngles[currentTargetIndex]
	
	if targetAngle != null:
		var clockwiseAngle = 0
		var antiClockwiseAngle = 0
		if parentAngle > targetAngle:
			clockwiseAngle = DEGREES_IN_CIRCLE - parentAngle + targetAngle
			antiClockwiseAngle = parentAngle - targetAngle
		else:
			clockwiseAngle = targetAngle - parentAngle
			antiClockwiseAngle = DEGREES_IN_CIRCLE - targetAngle + parentAngle
		var shouldRotateClockwise = true
		if clockwiseAngle > antiClockwiseAngle:
			shouldRotateClockwise = false
		rotateToAngle(delta, targetAngle, shouldRotateClockwise)

func rotateToAngle(delta, rotationTarget, shouldRotateClockwise):
	var parentAngle = get_parent().rotation_degrees
	var angleToRotate = rotationSpeed * delta
	
	updateCurrentAngle(parentAngle, angleToRotate, shouldRotateClockwise)
	updateTargetAngle(parentAngle, angleToRotate, rotationTarget)
		
	get_parent().rotation_degrees = parentAngle
	
func updateCurrentAngle(currentAngle, angleToRotate, shouldRotateClockwise):
	if shouldRotateClockwise:
		currentAngle += angleToRotate
		if currentAngle >= DEGREES_IN_CIRCLE:
			currentAngle = fmod(currentAngle, DEGREES_IN_CIRCLE)
	else:
		currentAngle -= angleToRotate
		if currentAngle < 0:
			currentAngle = DEGREES_IN_CIRCLE - fmod(abs(currentAngle), DEGREES_IN_CIRCLE)

func updateTargetAngle(parentAngle, angleToRotate, rotationTarget):
	if abs(parentAngle + angleToRotate - rotationTarget) < angleToRotate:
		parentAngle = rotationTarget
		if currentTargetIndex < rotationAngles.size() - 1:
			currentTargetIndex += 1
		elif repeat:
			currentTargetIndex = 0
		else:
			currentTargetIndex = -1
			targetAngle = null
