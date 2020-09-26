extends Node

var fsm: StateMachine

var positionNode
var navigator
var speed
var mover
var investigatePoints = null
var targetInvestigatePoint = 0

func _init(_navigator, _positionNode, _speed, _mover):
	navigator = _navigator
	positionNode = _positionNode
	speed = _speed
	mover = _mover

func enter():
	#get tile enemy is on
	var tileMap = navigator.get_node("TileMap")
	var tileSet = tileMap.tile_set
	var cellCoords = tileMap.world_to_map(positionNode.position)
	var cell = tileMap.get_cellv(cellCoords)
	
	var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0)]
	
	#get tiles on 4 sides of that tile
	investigatePoints = []
	for direction in directions:
		var cellId = tileMap.get_cellv(cellCoords + direction)
		var nav2D = tileSet.tile_get_navigation_polygon(cellId)
		if nav2D != null:
			investigatePoints.append(tileMap.map_to_world(cellCoords + direction) + tileMap.cell_size / 2)
	print(investigatePoints)
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	if !investigatePoints.empty() and navigator != null:
		var navPath = navigator.get_simple_path(positionNode.global_position, investigatePoints[targetInvestigatePoint])
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() == 0:
			if reachedEnd():
				exit("Guarding")
		else:
			positionNode.rotation = lerp(positionNode.rotation, positionNode.global_position.direction_to(navPath[0]).angle(), 0.1)
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
	
func reachedEnd():
	targetInvestigatePoint = targetInvestigatePoint + 1
	if targetInvestigatePoint > investigatePoints.size() - 1:
		targetInvestigatePoint = 0
		return true
	return false
