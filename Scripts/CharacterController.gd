extends KinematicBody2D

export (Vector2) var zoomLevel = Vector2(0.8, 0.8)
onready var fsm: StateMachine = get_node("StateMachine")
onready var fireTorchLightNode = get_node("FireTorchLight")
var lightLevel = 0
var lightSourceCounter = 0
var velocity = Vector2()

var speed = 200
export (int) var walkingSpeed = 60
export (int) var runningSpeed = 120

func _ready():
	fsm.state = fsm.get_children()[0]
	fsm._enter_state()

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
	
func setToRunningSpeed():
	speed = runningSpeed
	
func setToWalkingSpeed():
	speed = walkingSpeed
	
func addLight(lightLevelToAdd):
	lightLevel += lightLevelToAdd
	
func removeLight(lightLevelToRemove):
	lightLevel -= lightLevelToRemove
