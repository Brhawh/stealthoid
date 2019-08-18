extends Node2D

export(NodePath) var targetPath

var target
onready var tilemap = $"../../TileMap"

func _ready():
	target = get_node(targetPath)

func detect_target():
	var hitPos = []
	var target_extents = getCollisionShape2DExtentsOfTarget()
	var raycast = get_node("RayCast2D")
	raycast.add_exception(get_parent())
	for pos in target_extents:
		raycast.cast_to = global_position - target.global_position + pos
		var result = raycast.get_collider()
		if result && result.name == target.name:
			hitPos.append(result.position)
	return hitPos

func getCollisionShape2DExtentsOfTarget():
	var nodes = target.get_children()
	for node in nodes:
		if node.get_class() == "CollisionShape2D":
			return node.shape.points
	return []
