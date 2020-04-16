extends Node

var fsm: StateMachine

var patrolPoints = []
var speed = 100
var targetPatrolPoint = 0
var navPath
var navigator
var detector
var target
onready var mover = get_node("../../Mover")
onready var eldestParent = get_parent().get_parent()

func enter():
	return

func exit(next_state):
	target = null
	navPath = null
	fsm.change_to(next_state)

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if !patrolPoints.empty():
		navPath = navigator.get_simple_path(eldestParent.global_position, patrolPoints[targetPatrolPoint])
		navPath = mover.moveAlongPath(delta, speed, navPath, eldestParent)
		if navPath.size() == 0:
			var reachedEnd = targetNextPatrolPoint()
			if reachedEnd:
				exit("Guarding")
		else:
			eldestParent.look_at(navPath[0])
			
	if target != null:
		detector.target = target
		var hitPos = detector.detect_target()
		if !hitPos.empty() && target.lightLevel > 0:
			get_node("../Chasing").target = target
			exit("Chasing")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
		
func targetNextPatrolPoint():
	targetPatrolPoint = targetPatrolPoint + 1
	if targetPatrolPoint > patrolPoints.size() - 1:
		targetPatrolPoint = 0
		return true
	return false