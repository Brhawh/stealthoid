extends KinematicBody2D

onready var rotator = $Rotator
onready var detector = $Detector
onready var navigator: Navigation2D = get_node("../Navigation2D")

# PlayerDetection
var target
var hitPos
var playerSpotted = false
var laserColour = Color(1.0, .329, .298)

# Navigation
var navPath = []
var speed = 150.0
	
func _draw():
	if target && playerSpotted:
		for hit in hitPos:
			draw_circle((hit - position).rotated(-rotation), 5, laserColour)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laserColour)

func _physics_process(delta):
	update()
	if target:
		hitPos = detector.detect_target()
		if !hitPos.empty() && target.lightLevel > 0:
			playerSpotted = true
			navPath = navigator.get_simple_path(global_position, target.global_position)
			look_at(target.position)
		else:
			if playerSpotted:
				look_at(navPath[0])
			playerSpotted = false
			
	if navPath:
		moveAlongPath(delta)

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character":
		target = body

func _on_EnemyViewRadius_body_exited(body):
	if body == target:
		target = null
		
func moveAlongPath(delta):
	var moveDistance = speed * delta
	var startPoint = position
	for i in range(navPath.size()):
		var distToNext = startPoint.distance_to(navPath[0])
		if moveDistance <= distToNext and moveDistance >- 0.0:
			position = startPoint.linear_interpolate(navPath[0], moveDistance / distToNext)
			break
		elif moveDistance < 0.0:
			position = navPath[0]
		moveDistance -= distToNext
		startPoint = navPath[0]
		navPath.remove(0)
