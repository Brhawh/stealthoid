extends TileMap

onready var pressurePlateScene = preload("res://scenes/PressurePlateDart.tscn")

func _ready():
	generatePressurePlates()

func generatePressurePlates():
	for tileNo in get_used_cells():
		if get_cellv(tileNo) == tile_set.find_tile_by_name("PressurePlate"):
			spawnPressurePlate(tileNo)


func spawnPressurePlate(tileNo):
	var pressurePlate = pressurePlateScene.instance()
	var world_pos = map_to_world(tileNo)
	pressurePlate.global_position =  (world_pos) + Vector2((cell_size.x) / 2, (cell_size.y) / 2)
	call_deferred("add_child", pressurePlate)
