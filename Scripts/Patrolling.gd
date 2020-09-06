extends Node

var fsm: StateMachine

var patrolPoints = []
var speed = 100
var targetPatrolPoint = 0
var navPath
var navigator
var detector
onready var target = get_parent().get_parent().target
onready var mover = get_node("../../Mover")
onready var eldestParent = get_parent().get_parent()

func enter():
	return

func exit(next_state):
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
			if reachedEnd():
				exit("Guarding")
		else:
			eldestParent.rotation = lerp(eldestParent.rotation, eldestParent.global_position.direction_to(navPath[0]).angle(), 0.1)
			
	if target != null:
		var hitPos = detector.detect_target(target)
		if !hitPos.empty() && target.lightLevel > 0:
			#get_node("../Chasing").target = target
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
		
func reachedEnd():
	targetPatrolPoint = targetPatrolPoint + 1
	if targetPatrolPoint > patrolPoints.size() - 1:
		targetPatrolPoint = 0
		return true
	return false


func _on_Enemy_targetChanged():
	target = get_parent().get_parent().target
