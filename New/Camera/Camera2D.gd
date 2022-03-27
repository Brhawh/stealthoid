extends Camera2D

func _ready():
	zoom = get_parent().zoomLevel
	# current global position - cell size * number of cells / scale factor
	limit_left = get_parent().global_position.x - 32 * 9 / 2 
	limit_right = get_parent().global_position.x + 32 * 9 / 2
	print(limit_left, limit_right)
	

