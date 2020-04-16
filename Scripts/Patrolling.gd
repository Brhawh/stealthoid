extends Node

var fsm: StateMachine

var patrolPoints = []
var speed = 100
var targetPatrolPoint = 0
var navPath
var navigator
var detector
var target

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
		navPath = navigator.get_simple_path(get_parent().get_parent().global_position, patrolPoints[targetPatrolPoint])
		moveAlongPath(delta)
		if navPath.size() == 0:
			var reachedEnd = targetNextPatrolPoint()
			if reachedEnd:
				exit("Guarding")
		else:
			get_parent().get_parent().look_at(navPath[0])
			
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
	
func moveAlongPath(delta):
	var moveDistance = speed * delta
	var startPoint = get_parent().get_parent().position
	# The reason for using a for loop here is so that if the first navPath point is the same position as the
	# enemy's position then it will remove that one and try the next one instead until it finds a position that
	# actually requires it to move. Otherwise the enemy doesn't move when it spots the player.
	for i in navPath.size():
		var distToNext = startPoint.distance_to(navPath[0])
		if moveDistance <= distToNext and moveDistance >- 0.0:
			get_parent().get_parent().position = startPoint.linear_interpolate(navPath[0], moveDistance / distToNext)
			break
		elif distToNext <= 5.0:
			get_parent().get_parent().position = navPath[0]
		moveDistance -= distToNext
		startPoint = navPath[0]
		navPath.remove(0)