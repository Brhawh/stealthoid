extends Area2D

onready var boulder = get_node("Boulder")

func _ready():
	pass

func _on_PressurePlate_body_entered(body):
	if(body.name == "Character"):
		boulder.canMove = true
