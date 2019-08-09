extends Area2D

export(Array, NodePath) var gates

func _on_LeverArea2D_body_entered(body):
	if body.get_name() == "Character":
		get_parent().get_node("TileMap").leverPulled(position, gates);
