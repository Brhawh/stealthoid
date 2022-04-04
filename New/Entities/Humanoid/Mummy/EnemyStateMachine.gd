extends "res://Entities/Humanoid/StateMachine.gd"

class_name EnemyStateMachine

# State Indicators
var patrol_indicator = preload("res://Entities/Humanoid/Mummy/States/Patrolling/patrolling_indicator.png")
var attack_indicator = preload("res://Entities/Humanoid/Mummy/States/Attacking/attacking_indicator.png")
var chase_indicator = preload("res://Entities/Humanoid/Mummy/States/Chasing/chasing_indicator.png")
var guard_indicator = preload("res://Entities/Humanoid/Mummy/States/Guarding/guardin_indicator.png")
var investigate_indicator = preload("res://Entities/Humanoid/Mummy/States/Investigating/investigating_indicator.png")
var sleeping_indicator = preload("res://Entities/Humanoid/Mummy/States/Sleeping/sleeping_indicator.png")

onready var indicator_sprite = $"../StateIndicatorSprite"

func handleTargetDetected(target):
	if state.name != "Chasing":
		state.exit("Chasing")
		get_parent().get_node("AnimationPlayer").play("Alerted")
		get_node("Chasing").handleTargetDetected(target)
	else:
		state.handleTargetDetected(target)

func handleTargetLost():
	if state.name == "Chasing":
		state.handleTargetLost()
		
func change_to(new_state):
	.change_to(new_state)
	
	match new_state:
		"Patrolling":
			indicator_sprite.set_texture(patrol_indicator)
		"Guarding":
			indicator_sprite.set_texture(guard_indicator)
		"Chasing":
			indicator_sprite.set_texture(chase_indicator)
		"Investigating":
			indicator_sprite.set_texture(investigate_indicator)
		"Attacking":
			indicator_sprite.set_texture(attack_indicator)
		"Sleeping":
			indicator_sprite.set_texture(sleeping_indicator)

func enterSleep():
	if state.name != "Sleeping":
		state.exit("Sleeping")
	
func wakeUp():
	if state.name == "Sleeping":
		state.exit("Guarding")
