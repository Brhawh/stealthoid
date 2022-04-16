extends KinematicBody2D

export (Vector2) var zoomLevel = Vector2(0.8, 0.8)
onready var fsm: StateMachine = get_node("StateMachine")
var velocity = Vector2()

var hasTorch = true
var torchOn = true
var speed = 200 * transform.get_scale().x
export (int) var walkingSpeed = 60
export (int) var runningSpeed = 120
var lightLevel = 10

# var itemHandler = load("res://Scripts/ItemHandler.gd").new()
onready var Torch = get_node("Torch")

#1=up, 2=up+left, 3=up+right, 4=left, 5=right, 6=down, 7 = down+left, 8= down+right
var direction = -1

func _ready():
	# Torch.energy = 0
	fsm.state = fsm.get_children()[0]
	fsm._enter_state()
	# add_child(itemHandler)

func get_input():		
	velocity = Vector2()

	

	velocity = velocity.normalized() * speed

func death():
	#get_tree().change_scene("res://scenes/PyramidLevel1.tscn")
	pass

func _physics_process(delta):
	fsm.physics_process(delta)
	# get_input()
	# velocity = move_and_slide(velocity)

func Door(var otherDoor, var offset):
	position.y = get_node(otherDoor).get_position().y + offset
	
func updateAnimationSpeed(animationSpeed = 1):
	$AnimatedSprite.speed_scale = animationSpeed
	pass
	
func setToRunningSpeed():
	speed = runningSpeed * transform.get_scale().x
	$AnimatedSprite.speed_scale = 2
	
func setToWalkingSpeed():
	speed = walkingSpeed * transform.get_scale().x
	$AnimatedSprite.speed_scale = 1


func _on_CanvasLayer_use_move_vector(move_vector):
	var r = move_vector.x > 0
	var u = move_vector.y < 0
	
	if abs(move_vector.x) > abs(move_vector.y):
		if r:
			direction = 1
		else:
			direction = 3
	else:
		if u:
			direction = 4
		else:
			direction = 2
	velocity = move_and_slide(move_vector * speed)
