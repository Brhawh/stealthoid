extends CanvasLayer

signal use_move_vector

var move_vector = Vector2(0, 0)
var joystick_active = false

onready var inner_circle = get_node("InnerCircle")
onready var touch_screen_button = get_node("TouchScreenButton")

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if touch_screen_button.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			inner_circle.position = event.position
			inner_circle.visible = true
			
	if event is InputEventScreenTouch:
		if event.pressed == false:
			print("hiding")
			joystick_active = false
			inner_circle.visible = false

func _physics_process(_delta):
	if joystick_active:
		emit_signal("use_move_vector", move_vector)

func calculate_move_vector(event_position):
	var texture_center = touch_screen_button.position + Vector2(32, 32) * touch_screen_button.scale
	return (event_position - texture_center).normalized()
