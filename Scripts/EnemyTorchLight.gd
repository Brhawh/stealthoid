extends Area2D
var lightLevelEmitted = 10

func _on_Area2D_body_entered(body):
	if body.is_in_group("light_trackers"):
		body.addLight(lightLevelEmitted)


func _on_Area2D_body_exited(body):
	if body.is_in_group("light_trackers"):
		body.removeLight(lightLevelEmitted)
