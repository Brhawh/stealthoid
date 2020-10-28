extends Area2D

var tilemap
var tileset
onready var bulletScene = preload("res://scenes/Bullet.tscn")

func _ready():
	tilemap = get_parent()
	tileset = tilemap.tile_set


func _on_PressurePlate_body_entered(body):
	if(body.name == "Character"):
		var pressurePlateTile = tilemap.world_to_map(position)
		for tileNo in tilemap.get_used_cells():
			if tilemap.get_cellv(tileNo) == tileset.find_tile_by_name("WallShooter") && ((pressurePlateTile.x == tileNo.x) || (pressurePlateTile.y == tileNo.y)):
				spawnBullet(tileNo)

func spawnBullet(tileNo):
	print(tileNo)
	var bullet = bulletScene.instance()
	if tilemap.is_cell_x_flipped(tileNo.x, tileNo.y) && tilemap.is_cell_y_flipped(tileNo.x, tileNo.y):
		# x + y = left wall
		bullet.rotation_degrees = 0
		bullet.global_position =  tilemap.map_to_world(tileNo) + Vector2(24, 8)
	elif tilemap.is_cell_y_flipped(tileNo.x, tileNo.y):
		# y flipped = upper wall
		bullet.rotation_degrees = 90
		bullet.global_position =  tilemap.map_to_world(tileNo) + Vector2(8, 24)
	elif tilemap.is_cell_x_flipped(tileNo.x, tileNo.y):
		# x flipped = lower wall
		bullet.rotation_degrees = -90
		bullet.global_position =  tilemap.map_to_world(tileNo) + Vector2(8, -8)
	else: 
		# none flipped right wall
		bullet.rotation_degrees = 180
		bullet.global_position =  tilemap.map_to_world(tileNo) + Vector2(-8, 8)
	get_parent().get_parent().call_deferred("add_child", bullet)
