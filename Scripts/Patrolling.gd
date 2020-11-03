extends Node

var fsm: EnemyStateMachine

var patrolPoints = []
var speed = 100
var targetPatrolPoint = 0
var navPath
var navigator
var mover
var positionNode
var rotationHandler
	
func setUp(parentNode: EnemyController):
	patrolPoints = parentNode.patrolPoints
	speed = parentNode.speed
	navigator = parentNode.navigator
	mover = parentNode.mover
	positionNode = parentNode
	rotationHandler = parentNode.rotationHandler

func enter():
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if !patrolPoints.empty() and navigator != null:
		navPath = navigator.get_simple_path(positionNode.global_position, patrolPoints[targetPatrolPoint])
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() == 0:
			if reachedEnd():
				exit("Guarding")
		else:
			positionNode.rotation = rotationHandler.lerpAngle(positionNode.rotation, positionNode.global_position.direction_to(navPath[0]).angle(), 0.08)
	return delta
		
func reachedEnd():
	targetPatrolPoint = targetPatrolPoint + 1
	if targetPatrolPoint > patrolPoints.size() - 1:
		targetPatrolPoint = 0
		return true
	return false
