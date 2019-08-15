extends KinematicBody2D

onready var rotator = preload("RotateToAngle.gd").new()

# PlayerDetection
var target
var hitPos
var laserColour = Color(1.0, .329, .298)
	
func _draw():
	if target:
		for hit in hitPos:
			draw_circle((hit - position).rotated(-rotation), 5, laserColour)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laserColour)

func _physics_process(delta):
	update()
	if target:
		detect_target()
	
func detect_target():
	hitPos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node("PlayerCollisionShape2D").shape.points
	target_extents.append(target.position)
	for pos in target_extents:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			if result.collider.name == "Character":
				hitPos.append(result.position)
				if target.lightLevel > 0:
					print("Target Spotted")

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character":
		print(body.name + " within range of visibility.")
		target = body

func _on_EnemyViewRadius_body_exited(body):
	if body == target:
		target = null
		print("Target lost")
