extends Area2D
var lightLevelEmitted = 10

# stores lists of size 2, first item is the body, second is if light is being
# applied to it. This is false for example if the enemy is in the area2D but is
# behind a wall.
var body_trackers = []

func _on_Area2D_body_entered(body):
	if body.is_in_group("light_trackers"):
		body_trackers.append([body, false])

func _on_Area2D_body_exited(body):
	if body.is_in_group("light_trackers"):
		for body_tracker in body_trackers:
			if body_tracker[0] == body:
				if body_tracker[1]:
					body.removeLight(lightLevelEmitted)
				body_trackers.remove(body_trackers.find(body_tracker))

func _physics_process(delta):
	for body_tracker in body_trackers:
		var spaceState = get_world_2d().direct_space_state
		var result = spaceState.intersect_ray(global_position, body_tracker[0].global_position, [get_parent()])
		if result and result.collider == body_tracker[0]:
			if !body_tracker[1]:
				body_tracker[0].addLight(lightLevelEmitted)
				body_tracker[1] = true
		elif body_tracker[1]:
			body_tracker[1] = false
			body_tracker[0].removeLight(lightLevelEmitted)
