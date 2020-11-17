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
	mover.targetNode = target
	return

func exit(next_state):
	target = null
	mover.targetNode = null
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if target != null:
		var distanceToTarget = positionNode.global_position.distance_to(target.global_position)
		if distanceToTarget < 30:
			fsm.get_node("Attacking").target = target
			exit("Attacking")
	return delta

func handleTargetDetected(_target):
	target = _target
	
func handleTargetLost():
	mover.targetNode = null
	target = null
	
func reachedTargetPosition():
	exit("Investigating")
