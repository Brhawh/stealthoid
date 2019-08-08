extends Area2D

func _on_LeverArea2D_body_entered(body):
	if body.get_name() == "Character":
		get_parent().get_node("TileMap").leverPulled(position);
