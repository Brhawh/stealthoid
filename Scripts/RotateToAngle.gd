extends Node

export(Array, float) var rotationAngles
export(float) var rotationSpeed
export(bool) var repeat

var currentTargetIndex = 0
var targetAngle

func _physics_process(delta):
	var parentAngle = get_parent().rotation_degrees
	
	if currentTargetIndex != -1:
		targetAngle = rotationAngles[currentTargetIndex]
	
	if targetAngle != null:
		var clockwiseAngle = 0
		var antiClockwiseAngle = 0
		if parentAngle > targetAngle:
			clockwiseAngle = 360 - parentAngle + targetAngle
			antiClockwiseAngle = parentAngle - targetAngle
		else:
			clockwiseAngle = targetAngle - parentAngle
			antiClockwiseAngle = 360 - targetAngle + parentAngle
		var shouldRotateClockwise = true
		if clockwiseAngle > antiClockwiseAngle:
			shouldRotateClockwise = false
		rotateToAngle(delta, targetAngle, shouldRotateClockwise)

func rotateToAngle(delta, rotationTarget, shouldRotateClockwise):
	
	var parentAngle = get_parent().rotation_degrees
	var angleToRotate = rotationSpeed * delta
	
	if shouldRotateClockwise:
		parentAngle += angleToRotate
	else:
		parentAngle -= angleToRotate
		
	if abs(parentAngle + angleToRotate - rotationTarget) < angleToRotate:
		parentAngle = rotationTarget
		if currentTargetIndex < rotationAngles.size() - 1:
			currentTargetIndex += 1
		elif repeat:
			currentTargetIndex = 0
		else:
			currentTargetIndex = -1
			targetAngle = null
		
	get_parent().rotation_degrees = parentAngle
