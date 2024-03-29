extends Node

var fsm: EnemyStateMachine

var hasAttacked = false
var canMove = true
var _timer
var target = null
const ATTACK = preload("res://Entities/Humanoid/Mummy/Attack.tscn")
var characterController = load("res://Entities/Humanoid/Character/CharacterController.gd").new()
var distanceToTarget

func setUp(parentNode):
	target = get_node("../../" + parentNode.targetPath)

func enter():
	return

func exit(next_state):
	target = null
	fsm.change_to(next_state)

func physics_process(delta):
	if target != null:
		distanceToTarget = get_parent().get_parent().global_position.distance_to(target.global_position)
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
			if canMove:
			 exit("Chasing")
	else:
		exit("Patrolling")
	return delta

func attackTimer():
	hasAttacked = true
	canMove = false
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.3)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	
func _on_Timer_timeout():
	hasAttacked = false
	canMove = true
	
	if distanceToTarget < 20:
		get_tree().change_scene("res://Scenes/GameOver.tscn")

func handleTargetDetected(_target):
	target = _target

func handleTargetLost():
	target = null
