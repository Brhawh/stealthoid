extends Navigation2D

signal navigationReady(navigation2DNode)

func _ready():
	connect("navigationReady", get_node("../Enemy"), "onNavigatorReady")
	emit_signal("navigationReady", self)
