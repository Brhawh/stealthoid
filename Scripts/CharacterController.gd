extends KinematicBody2D

export (Vector2) var zoomLevel = Vector2(0.8, 0.8)
onready var fsm: StateMachine = get_node("StateMachine")
onready var fireTorchLightNode = get_node("FireTorchLight")
var velocity = Vector2()

var speed = 200
export (int) var walkingSpeed = 60
export (int) var runningSpeed = 120

var lightTracker = load("res://Scripts/LightTracker.gd").new()

func _ready():
	remove_child(fireTorchLightNode)
	fsm.state = fsm.get_children()[0]
	fsm._enter_state()
	
	if has_node("FireTorchLight"):
		lightTracker.addLight(get_node("FireTorchLight").lightLevelEmitted)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	if velocity.x != 0 or velocity.y != 0:
		rotation = velocity.angle()

func death():
	#get_tree().change_scene("res://scenes/PyramidLevel1.tscn")
	pass

func _physics_process(delta):
	fsm.physics_process(delta)
	get_input()
	velocity = move_and_slide(velocity)

func Door(var otherDoor, var offset):
	position.y = get_node(otherDoor).get_position().y + offset
	
func updateAnimationSpeed(animationSpeed = 1):
	$AnimatedSprite.speed_scale = animationSpeed
	
func setToRunningSpeed():
	speed = runningSpeed
	$AnimatedSprite.speed_scale = 2
	
func setToWalkingSpeed():
	speed = walkingSpeed
	$AnimatedSprite.speed_scale = 1
