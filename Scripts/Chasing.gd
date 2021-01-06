extends Node

var fsm: EnemyStateMachine

var navigator
var mover
var positionNode
var target = null
	
func setUp(parentNode):
	positionNode = parentNode
	mover = parentNode.mover
	navigator = parentNode.navigator

func enter():
	mover.targetHandler = self
	mover.chaseTarget(target)
	return

func exit(next_state):
	target = null
	mover.stopMoving()
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if target != null:
		var distanceToTarget = positionNode.global_position.distance_to(target.global_position)
		if distanceToTarget < 20:
			fsm.get_node("Attacking").target = target
			exit("Attacking")
	return delta

func handleTargetDetected(_target):
	target = _target
	
func handleTargetLost():
	mover.clearTarget()
	target = null
	
func reachedTargetPosition():
	exit("Investigating")
