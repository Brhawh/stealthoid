extends Area2D

var speed = 100

func _ready():
	pass

func _process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "Character":
		get_tree().change_scene("res://scenes/GameOver.tscn")
	queue_free()
