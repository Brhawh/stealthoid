extends Node

const GameOverScreen = preload("res://Screens/Game Over/GameOver.tscn")

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
		if distanceToTarget < 10:
			var game_over = GameOverScreen.instance()
			add_child(game_over)
			move_child(game_over, 0)
			mover.clearTarget()
	return delta

func handleTargetDetected(_target):
	target = _target
	mover.chaseTarget(_target)
	
func handleTargetLost():
	mover.clearTarget()
	target = null
	
func reachedTargetPosition():
	exit("Investigating")
	
func chaseSound(soundSource):
	if target == null:
		mover.setTargetPosition(soundSource.global_position)
