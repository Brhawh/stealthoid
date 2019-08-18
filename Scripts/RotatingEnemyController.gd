extends KinematicBody2D

onready var rotator = $Rotator
onready var detector = $Detector

# PlayerDetection
var target
var hitPos
var playerSpotted = false
var laserColour = Color(1.0, .329, .298)
	
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
		else:
			playerSpotted = false
		print(playerSpotted)

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character":
		target = body

func _on_EnemyViewRadius_body_exited(body):
	if body == target:
		target = null
