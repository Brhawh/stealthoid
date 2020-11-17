extends "res://Scripts/StateMachine.gd"

class_name EnemyStateMachine

func handleTargetDetected(target):
	if state.name != "Chasing":
		get_node("Chasing").target = target
		state.exit("Chasing")
	else:
		state.handleTargetDetected(target)

func handleTargetLost():
	if state.name == "Chasing":
		state.handleTargetLost()
