extends KinematicBody2D

export (Vector2) var zoomLevel = Vector2(0.8, 0.8)
onready var fsm: StateMachine = get_node("StateMachine")
var velocity = Vector2()

var hasTorch = true
var torchOn = true
var speed = 200
export (int) var walkingSpeed = 60
export (int) var runningSpeed = 120

var lightTracker = load("res://Scripts/LightTracker.gd").new()
var itemHandler = load("res://Scripts/ItemHandler.gd").new()
onready var Torch = get_node("Torch")

#1=up, 2=up+left, 3=up+right, 4=left, 5=right, 6=down, 7 = down+left, 8= down+right
var direction = -1

func _ready():
	Torch.energy = 0
	fsm.state = fsm.get_children()[0]
	fsm._enter_state()
	add_child(itemHandler)

func _input(event):
	if Input.is_action_pressed('toggle_light') && hasTorch:
		if !torchOn:
			torchOn = true
			Torch.energy = 1
			lightTracker.addLight(10)
		elif torchOn:
			torchOn = false
			Torch.energy = 0
			lightTracker.removeLight(10)

func get_input():		
	velocity = Vector2()

	var r = int(Input.is_action_pressed("right")) << 1
	var l = int(Input.is_action_pressed("left")) << 2
	var d = int(Input.is_action_pressed("down")) << 3
	var u = int(Input.is_action_pressed("up")) << 4
	var n = r + l + d + u
	if n == d:
		direction = 6
	elif n == l:
		direction = 4
	elif n == u:
		direction = 1
	elif n == r: 
		direction = 5
	elif n == (u+l):
		direction = 2
	elif n == (u+r):
		direction = 3
	elif n == (d+l):
		direction = 7
	elif n == (d+r):
		direction = 8
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
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
	pass
	
func setToRunningSpeed():
	speed = runningSpeed
	$AnimatedSprite.speed_scale = 2
	
func setToWalkingSpeed():
	speed = walkingSpeed
	$AnimatedSprite.speed_scale = 1
