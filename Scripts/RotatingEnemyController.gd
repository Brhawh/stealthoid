extends KinematicBody2D

var maxWaitTime = 5
var facingRight = true
var rotationSpeed = 30
var currentWaitTime = 0
var degToRotateEachTime = 180
var currentRotation = 0

# PlayerDetection
var target
var hitPos
var laserColour = Color(1.0, .329, .298)
var lightLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentWaitTime = maxWaitTime
	
func _draw():
	if target:
		for hit in hitPos:
			draw_circle((hit - position).rotated(-rotation), 5, laserColour)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laserColour)

func _physics_process(delta):
	update()
	if currentWaitTime > 0:
			currentWaitTime -= delta
	elif currentWaitTime <= 0:
		turnToFaceOppositeDirection(delta)
		
	if target:
		detect_target()
	
func detect_target():
	hitPos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node("PlayerCollisionShape2D").shape.extents - Vector2(5, 5)
	var nw  = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, - target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, se, ne, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			if result.collider.name == "Character":
				hitPos.append(result.position)
				if target.lightLevel > 0:
					print("Target Spotted")
	
func turnToFaceOppositeDirection(delta):
	var degreesToRotate = rotationSpeed * delta
	rotation_degrees += degreesToRotate
	currentRotation += degreesToRotate
	if currentRotation > degToRotateEachTime:
		currentRotation = 0
		if facingRight:
			rotation_degrees = 180
			facingRight = false
		else: 
			rotation_degrees = 0
			facingRight = true
		currentWaitTime = maxWaitTime
		print("waiting")

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character":
		print(body.name + " within range of visibility.")
		target = body

func _on_EnemyViewRadius_body_exited(body):
	if body == target:
		target = null
		print("Target lost")
