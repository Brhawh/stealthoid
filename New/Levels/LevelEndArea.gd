extends Area2D

export var reference_path = ""

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		if reference_path == "":
			get_tree().change_scene("res://Screens/Game Over/GameOver.tscn")
		else:
			get_tree().change_scene(reference_path)
