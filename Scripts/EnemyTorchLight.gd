extends Area2D

var targetsInRange = []

func _physics_process(delta):
	update()
	for target in targetsInRange:
		var hitPos = []
		var spaceState = get_world_2d().direct_space_state
		var result = spaceState.intersect_ray(global_position, target.global_position, [get_parent()])
		if result:
			if result.collider.name == target.name:
				hitPos.append(result.collider.position)
		if hitPos.empty():
			target.lightLevel = 0
		else:
			target.lightLevel = 1
	return delta

func _on_EnemyTorchLight_body_entered(body):
	if not body.get("lightLevel") == null:
		targetsInRange.append(body)


func _on_EnemyTorchLight_body_exited(body):
	if not body.get("lightLevel") == null:
		var idx = targetsInRange.find(body)
		body.lightLevel = 0
		targetsInRange.remove(idx)
	
