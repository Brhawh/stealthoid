extends Node

var fsm: StateMachine

var navigator
var detector
onready var target = get_parent().get_parent().target

func enter():
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if target != null:
		var distanceToTarget = get_parent().get_parent().global_position.distance_to(target.global_position)
		if distanceToTarget < 30:
			pass
			#get_tree().queue_delete(get_tree())
		else:
			exit("Chasing")
	else:
		exit("Patrolling")
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]


func _on_Enemy_targetChanged():
	target = get_parent().get_parent().target
