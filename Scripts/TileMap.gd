extends TileMap

var _tileset = get_tileset()
    
func leverPulled(var charPos):
	var tile_pos = world_to_map(charPos)
	set_cellv(tile_pos, _tileset.find_tile_by_name("leverPulled"))
	set_cellv(Vector2(30, 8), _tileset.find_tile_by_name("path"))
	set_cellv(Vector2(30, 7), _tileset.find_tile_by_name("path"))
	