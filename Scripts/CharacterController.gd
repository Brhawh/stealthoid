extends KinematicBody2D

export (int) var speed = 200
export (Vector2) var zoomLevel = Vector2(0.8, 0.8)
onready var fsm: StateMachine = get_node("StateMachine")
var lightLevel = 0
var velocity = Vector2()

var walkingSpeed = 50
var runningSpeed = 100

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

func _physics_process(delta):
	fsm._physics_process(delta)
	get_input()
	velocity = move_and_slide(velocity)

func Door(var otherDoor, var offset):
	position.y = get_node(otherDoor).get_position().y + offset 
	
func startRunning():
	speed = runningSpeed
	
func stopRunning():
	speed = walkingSpeed
