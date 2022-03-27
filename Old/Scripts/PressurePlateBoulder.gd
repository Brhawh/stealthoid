extends Area2D

onready var boulder = get_node("Boulder")
var fired = false

func _ready():
	pass

func _on_PressurePlate_body_entered(body):
	if(body.name == "Character" && !fired):
		fired = true
		boulder.canMove = true
