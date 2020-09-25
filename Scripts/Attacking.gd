extends Node

var fsm: StateMachine

var navigator
var detector
var hasAttacked = false
var canMove = true
var _timer
var target
const ATTACK = preload("res://scenes/Attack.tscn")

func _init(_target, _navigator, _detector):
	target = _target
	navigator = _navigator
	detector = _detector

func enter():
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if target != null:
		var distanceToTarget = get_parent().get_parent().global_position.distance_to(target.global_position)
		if distanceToTarget < 20:
			if !hasAttacked:
				#spawn attack sprite
				var attack = ATTACK.instance()
				var enemyPos = get_parent().get_parent().position
				var playerPos = target.position
				var attackPos = (enemyPos + playerPos) / 2
				attack.position = attackPos
				attack.rotation_degrees = get_parent().get_parent().rotation_degrees
				add_child(attack)
				# lock movement of enemy
				attackTimer()
		else:
			#print("You died")
			if canMove:
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

func attackTimer():
	hasAttacked = true
	canMove = false
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()

func _on_Timer_timeout():
	hasAttacked = false
	canMove = true

func _on_Enemy_targetChanged():
	target = get_parent().get_parent().target
