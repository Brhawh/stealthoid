extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyTorchLight_body_entered(body):
	var space_state = get_parent().get_world_2d().direct_space_state
	var result = space_state.intersect_ray(get_parent().position, body.position, [get_parent()], get_parent().collision_mask)
	if result && result.collider.name == "Character":
		body.lightLevel = 1
		print("LightLevel increased")


func _on_EnemyTorchLight_body_exited(body):
	var space_state = get_parent().get_world_2d().direct_space_state
	var result = space_state.intersect_ray(get_parent().position, body.position, [get_parent()], get_parent().collision_mask)
	if result && result.collider.name == "Character":
		body.lightLevel = 0
		print("LightLevel decreased")
