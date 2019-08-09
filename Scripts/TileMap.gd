extends TileMap

var _tileset = get_tileset()
    
func leverPulled(var charPos, var gates):
	#TODO add if to check if change back
	set_cellv(world_to_map(charPos), _tileset.find_tile_by_name("leverPulled"))
	for i in range(0, gates.size()):
    	set_cellv(world_to_map(get_node(gates[i]).get_position()), _tileset.find_tile_by_name("path"))
		