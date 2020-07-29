extends Node

var walkingRadius = 30
var runningRadius = 60

var enemies = []

func setWalkingRadius():
	get_node("SoundRadiusArea2D/CollisionShape2D").shape.radius = walkingRadius
	
func setRunningRadius():
	get_node("SoundRadiusArea2D/CollisionShape2D").shape.radius = runningRadius

func _on_SoundRadiusArea2D_body_entered(body):
	enemies.append(body)

func _on_SoundRadiusArea2D_body_exited(body):
	enemies.erase(body)
	
func emitSound():
	for enemy in enemies:
		enemy.detectSound(get_parent().get_parent())
