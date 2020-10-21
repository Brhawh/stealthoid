extends Navigation2D

signal navigationReady(navigation2DNode)

func _ready():
	connect("navigationReady", get_node("../Enemy"), "onNavigatorReady")
	connect("navigationReady", get_node("../Enemy2"), "onNavigatorReady")
	connect("navigationReady", get_node("../Enemy3"), "onNavigatorReady")
	connect("navigationReady", get_node("../Enemy4"), "onNavigatorReady")
	emit_signal("navigationReady", self)
