extends Node

var fsm: EnemyStateMachine

var mover
var zeeAnimation = load("res://Scenes/SleepingZeesAnimation.tscn").instance()
var parent

func setUp(parentNode):
	parent = parentNode 
	mover = parentNode.mover

func enter():
	mover.stopMoving()
	add_child(zeeAnimation)
	zeeAnimation.global_position = parent.global_position + Vector2(0, -10)
	zeeAnimation.play("SleepingZees")
	return

func exit(next_state):
	zeeAnimation.stop()
	remove_child(zeeAnimation)
	fsm.change_to(next_state)

func physics_process(delta):
	return delta
