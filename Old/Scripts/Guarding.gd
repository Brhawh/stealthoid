extends Node

var fsm: EnemyStateMachine

var rotationDegrees
var targetRotationDegrees = 0
var rotationSpeed = 40
var guardLocation
var paused
var rotationHandler
var atGuardLocation
onready var mover
onready var positionNode

var _timer

const DEGREES_IN_CIRCLE = 360

func setUp(parentNode):
	positionNode = parentNode
	mover = parentNode.mover
	guardLocation = parentNode.guardPostLocation
	rotationDegrees = parentNode.guardingDegrees
	rotationHandler = parentNode.rotationHandler

func enter():
	mover.targetHandler = self
	mover.setTargetPosition(guardLocation)
	atGuardLocation = false
	return

func exit(next_state):
	paused = false
	targetRotationDegrees = 0
	fsm.change_to(next_state)

func physics_process(delta):
	if atGuardLocation and !paused:
		if rotationDegrees.size() > 0:
			rotateToNext(delta)
		else:
			exit("Patrolling")
	return delta
	
func rotateToNext(delta):
	var oldRotation = positionNode.rotation
	var newRotation = rotationHandler.lerpAngle(oldRotation, deg2rad(rotationDegrees[targetRotationDegrees]), positionNode.speed)
	positionNode.rotation = newRotation
	if abs(rad2deg(newRotation - oldRotation)) <= 0.1:
		pause("targetNextRotation")
	return delta
	
func targetNextRotation():
	targetRotationDegrees = targetRotationDegrees + 1
	if targetRotationDegrees > rotationDegrees.size() - 1:
		targetRotationDegrees = 0
		exit("Patrolling")
	paused = false

func positionsWithinRange(pos1, pos2, acceptableRange):
	return acceptableRange > pos1.distance_to(pos2)
	
func pause(timeoutFunc):
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, timeoutFunc)
	_timer.set_wait_time(2)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	paused = true
	
func reachedTargetPosition():
	atGuardLocation = true
