extends Node2D

onready var tilemap = $TileMap
onready var cam = $Character/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits()

func set_camera_limits():
	var map_limits = tilemap.get_used_rect()
	var map_cellsize = tilemap.cell_size
	cam.limit_left = map_limits.position.x * map_cellsize.x
	cam.limit_right = map_limits.end.x * map_cellsize.x
	cam.limit_top = map_limits.position.y * map_cellsize.y
	cam.limit_bottom = map_limits.end.y * map_cellsize.y
