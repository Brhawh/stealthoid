extends Node

var fsm: EnemyStateMachine

var rotationDegrees
var targetRotationDegrees = 0
var rotationSpeed = 40
var guardLocation
var navigator
var navPath
var speed
var paused
var rotationHandler
onready var mover
onready var positionNode

var _timer

const DEGREES_IN_CIRCLE = 360

func setUp(parentNode):
	navigator = parentNode.navigator
	positionNode = parentNode
	mover = parentNode.mover
	speed = parentNode.speed
	guardLocation = parentNode.guardPostLocation
	rotationDegrees = parentNode.guardingDegrees
	rotationHandler = parentNode.rotationHandler

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
			positionNode.rotation = rotationHandler.lerpAngle(positionNode.rotation, targetAngle, 0.08)
	return delta
	
func rotateToNext(delta):
	var oldRotation = positionNode.rotation
	var newRotation = rotationHandler.lerpAngle(oldRotation, deg2rad(rotationDegrees[targetRotationDegrees]), 0.08)
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
	return (abs(pos1.x - pos2.x) < acceptableRange && abs(pos1.y - pos2.y) < acceptableRange)
	
func pause(timeoutFunc):
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, timeoutFunc)
	_timer.set_wait_time(2)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	paused = true
