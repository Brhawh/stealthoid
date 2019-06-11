extends KinematicBody2D

var maxWaitTime = 5
var facingRight = true
var rotationSpeed = 30
var currentWaitTime = 0
var degToRotateEachTime = 180
var currentRotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentWaitTime = maxWaitTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentWaitTime > 0:
		currentWaitTime -= delta
	elif currentWaitTime <= 0:
		turnToFaceOppositeDirection(delta)
	
func turnToFaceOppositeDirection(delta):
	var degreesToRotate = rotationSpeed * delta
	rotation_degrees += degreesToRotate
	currentRotation += degreesToRotate
	if currentRotation > degToRotateEachTime:
		currentRotation = 0
		if facingRight:
			rotation_degrees = 180
			facingRight = false
		else: 
			rotation_degrees = 0
			facingRight = true
		currentWaitTime = maxWaitTime
		print("waiting")