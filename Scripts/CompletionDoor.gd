extends Area2D

export(NodePath) var otherDoor
export(int) var offset

func _on_Area2D_body_entered(body):
	if body.get_name() == "Character":
        body.Door(otherDoor, offset)