extends KinematicBody2D

export (float) var speed = 1
export (Vector2) var destination
export (Vector2) var initial
var canMove = false

func _ready():
	pass

func _process(delta):
	if position <= destination && canMove:
		position.x += speed
	elif position >= destination && canMove:
		queue_free()
	return delta

func _on_Area2D_body_entered(body):
	if body.get_name() == "Character":
		print("blam")
		get_tree().change_scene("res://scenes/GameOver.tscn")
