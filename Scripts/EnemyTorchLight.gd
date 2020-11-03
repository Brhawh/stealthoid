extends Area2D

func _on_EnemyTorchLight_body_entered(body):
	if not body.get("lightLevel") == null:
		body.lightSourceCounter += 1


func _on_EnemyTorchLight_body_exited(body):
	if not body.get("lightLevel") == null:
		body.lightSourceCounter -= 1
	
