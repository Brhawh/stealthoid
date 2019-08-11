extends KinematicBody2D

export (int) var speed = 200
var lightLevel = 0

var velocity = Vector2()

func get_input():
	look_at(get_global_mouse_position())
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

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func Door(var otherDoor, var offset):
	position.y = get_node(otherDoor).get_position().y + offset 

func _on_EnemyTorchLight_body_entered(body):
	if body == self:
		lightLevel = 1

func _on_EnemyTorchLight_body_exited(body):
	if body == self:
		lightLevel = 0
