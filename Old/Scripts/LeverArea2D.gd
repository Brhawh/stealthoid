extends Area2D

export(Array, NodePath) var gates
onready var state = 0

func _on_LeverArea2D_body_entered(body):
	if body.get_name() == "Character":
		get_parent().get_node("Navigation2D/TileMap").leverPulled(position, gates, state)
		if state == 0:
			state = 1
		else:
			state = 0
		
