extends Particles2D

var timeAlive = 0
var start = false

func _process(delta):
	 if is_emitting():
		  timeAlive += delta

	 if timeAlive >= lifetime:
		  queue_free()
