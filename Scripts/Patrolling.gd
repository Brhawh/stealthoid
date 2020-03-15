extends Node

var fsm: StateMachine

var patrolPoints
var speed
var targetPatrolPoint = 0

func enter():
	print("Patrol Points: ", patrolPoints)

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	moveAlongPath(delta)
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]

func moveAlongPath(delta):
	var moveDistance = speed * delta
	var startPoint = get_parent().get_parent().position
	var distToNext = startPoint.distance_to(patrolPoints[targetPatrolPoint])
	if moveDistance <= distToNext and moveDistance > 0.0:
		get_parent().get_parent().position = startPoint.linear_interpolate(patrolPoints[targetPatrolPoint], moveDistance / distToNext)
	elif moveDistance > distToNext:
		get_parent().get_parent().position = patrolPoints[targetPatrolPoint]
		targetNextPatrolPoint()
		
func targetNextPatrolPoint():
	targetPatrolPoint = targetPatrolPoint + 1
	if targetPatrolPoint > patrolPoints.size() - 1:
		targetPatrolPoint = 0
	get_parent().get_parent().look_at(patrolPoints[targetPatrolPoint])