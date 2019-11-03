extends Node2D

export(NodePath) var targetPath

onready var target = get_node(targetPath)
onready var tilemap = $"../../Navigation2D/TileMap"

func detect_target():
	var hitPos = []
	var target_extents = getCollisionShape2DExtentsOfTarget(target)
	var spaceState = get_world_2d().direct_space_state
	for pos in target_extents:
		var result = spaceState.intersect_ray(global_position, target.global_position + pos, [get_parent()])
		if result && result.collider.name == target.name:
			hitPos.append(result.position)
	return hitPos

func getCollisionShape2DExtentsOfTarget(collisionTarget):
	var nodes = collisionTarget.get_children()
	for node in nodes:
		if node.get_class() == "CollisionShape2D":
			return node.shape.points
	return []
