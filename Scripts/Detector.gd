extends Node2D

onready var target = null
onready var tilemap = $"../../../Navigation2D/TileMap"

func detect_target():
	var hitPos = []
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(global_position, target.global_position, [get_parent()])
	if result && result.collider.name == target.name:
		hitPos.append(result.position)
	return hitPos
