extends Node2D

func detect_target(target):
	var hitPos = []
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(global_position, target.global_position, [get_parent()])
	if result && result.collider.name == target.name:
		hitPos.append(result.position)
	return hitPos
