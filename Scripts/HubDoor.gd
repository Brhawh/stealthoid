extends Area2D

func _on_ExitDoorArea2D_body_entered(body):
	if body.get_name() == "Character":
		get_tree().change_scene("res://scenes/Hub.tscn")