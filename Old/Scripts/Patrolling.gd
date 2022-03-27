extends Node

var fsm: EnemyStateMachine

var patrolPoints = []
var targetPatrolPoint = 0
var mover
var positionNode
	
func setUp(parentNode: EnemyController):
	patrolPoints = parentNode.patrolPoints
	mover = parentNode.mover
	positionNode = parentNode

func enter():
	mover.targetHandler = self
	if patrolPoints.size() > 0:
		mover.setTargetPosition(patrolPoints[targetPatrolPoint])
	else:
		exit("Guarding")
	return

func exit(next_state):
	targetPatrolPoint = 0
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	return delta
	
func reachedTargetPosition():
	if reachedEnd():
		exit("Guarding")
	else:
		mover.setTargetPosition(patrolPoints[targetPatrolPoint])
		
func reachedEnd():
	targetPatrolPoint = targetPatrolPoint + 1
	if targetPatrolPoint > patrolPoints.size() - 1:
		targetPatrolPoint = 0
		return true
	return false
