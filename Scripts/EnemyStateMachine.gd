extends "res://Scripts/StateMachine.gd"

class_name EnemyStateMachine

# State Indicators
var patrol_indicator = preload("res://Assets/patrolling_indicator.png")
var attack_indicator = preload("res://Assets/attacking_indicator.png")
var chase_indicator = preload("res://Assets/chasing_indicator.png")
var guard_indicator = preload("res://Assets/guardin_indicator.png")
var investigate_indicator = preload("res://Assets/investigating_indicator.png")
var sleeping_indicator = preload("res://Assets/sleeping_indicator.png")

onready var indicator_sprite = $"../StateIndicatorSprite"

func handleTargetDetected(target):
	if state.name != "Chasing" && state.name != "Attacking":
		get_node("Attacking").target = target
		state.exit("Chasing")
		get_node("Chasing").handleTargetDetected(target)
	else:
		state.handleTargetDetected(target)

func handleTargetLost():
	if state.name == "Chasing":
		state.handleTargetLost()
	if state.name == "Attacking":
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
