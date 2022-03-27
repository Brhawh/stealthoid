extends KinematicBody2D

var player = null
var beingPickedUp = false

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name = "Fire Torch"

var time = 0
onready var noiseTexture = ($base_texture_fire.get_material().get_shader_param("noise") as NoiseTexture)

func _physics_process(delta):
	if beingPickedUp:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 20:
			queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)

func _process(delta):
	time += delta * 75
	var offset = noiseTexture.noise.get_noise_1d(time)
	$Light2D.scale = Vector2(1.5 + offset/3, 1.5 + offset/3)

func _on_Area2D_body_entered(body):
	if body.name == "Character":
		body.itemHandler.add_item_in_range(self)

func _on_Area2D_body_exited(body):
	if body.name == "Character":
		body.itemHandler.remove_item_out_range(self)

func pickUpItem(body):
	player = body
	beingPickedUp = true
