extends KinematicBody2D

onready var rotator = $Rotator
onready var detector = $Detector
onready var navigator: Navigation2D = get_node("../Navigation2D")

# PlayerDetection
var target = null
var hitPos
var playerSpotted = false
var laserColour = Color(1.0, .329, .298)

# Navigation
var navPath = []
var speed = 150.0

# Rotation tracking
var rotationTarget
var isWaiting = false
var waitTime = 3.0

# Original guard post
export(Vector2) var guardPostLocation

# Searching behaviour
var isSearching = false
	
func _draw():
	if target != null && playerSpotted:
		for hit in hitPos:
			draw_circle((hit - position).rotated(-rotation), 5, laserColour)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laserColour)

func _physics_process(delta):
	update()
	if target != null:
		hitPos = detector.detect_target()
		if !hitPos.empty() && target.lightLevel > 0: # Player is detected and visible
			playerSpotted = true
			rotator.targetRotation = null
			navPath = navigator.get_simple_path(global_position, target.global_position)
		else: # Enemy can not see player
			playerSpotted = false
			isWaiting = false
			
	if navPath:
		moveAlongPath(delta)
		
		if playerSpotted:
			look_at(target.position)
		elif navPath.size() > 0:
			look_at(navPath[0])
	
	var positionsInRange = positionsWithinRange(position, guardPostLocation, 5.0)
	if !navPath && !isSearching and !positionsInRange:
		navPath = navigator.get_simple_path(global_position, guardPostLocation)
	
	if !navPath && target == null: # Should rotate
		if rotator.targetRotation == null && !isWaiting: # Not currently rotating
			rotator.targetRotation = rand_range(1,361)
		elif rotator.targetRotation == null && isWaiting: #is rotating
			waitTime = waitTime - delta
			if waitTime < 0:
				isWaiting = false
				waitTime = 3.0
				
func positionsWithinRange(pos1, pos2, acceptableRange):
	if abs(pos1.x - pos2.x) < acceptableRange && abs(pos1.y - pos2.y) < acceptableRange:
		return true
	else:
		return false 

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
		
func rotateRandom():
	rotator.targetRotation = rand_range(1,361) 

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character":
		target = body

func _on_EnemyViewRadius_body_exited(body):
	if body == target:
		target = null
		

func _on_Rotator_finishedRotating():
	isWaiting = true
