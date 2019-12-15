extends Area2D


func _on_Treasure_body_entered(body):
	if body.get_name() == "Character":
		$Sprite.visible = false
