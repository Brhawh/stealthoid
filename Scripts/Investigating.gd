extends Node

var fsm: EnemyStateMachine

var positionNode
var navigator
var speed
var mover
var investigatePoints = null
var targetInvestigatePoint = 0
var paused = false

var _timer
	
func setUp(parentNode):
	positionNode = parentNode
	mover = parentNode.mover
	speed = parentNode.speed
	navigator = parentNode.navigator

func enter():
	#get tile enemy is on
	var tileMap = navigator.get_node("../TileMap")
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
	return

func exit(next_state):
	investigatePoints = null
	targetInvestigatePoint = 0
	paused = false
	fsm.change_to(next_state)

func physics_process(delta):
	if !investigatePoints.empty() and navigator != null && !paused:
		var navPath = navigator.get_simple_path(positionNode.global_position, investigatePoints[targetInvestigatePoint])
		navPath = mover.moveAlongPath(delta, speed, navPath, positionNode)
		if navPath.size() == 0:
			if reachedEnd():
				pause("returnToGuarding")
			else:
				pause("_on_Timer_timeout")
		else:
			positionNode.rotation = lerp(positionNode.rotation, positionNode.global_position.direction_to(navPath[0]).angle(), 0.08)
	return delta
	
func reachedEnd():
	targetInvestigatePoint = targetInvestigatePoint + 1
	if targetInvestigatePoint > investigatePoints.size() - 1:
		targetInvestigatePoint = 0
		return true
	return false
	
func _on_Timer_timeout():
	paused = false
	
func returnToGuarding():
	exit("Guarding")
	paused = false
	
func pause(timeoutFunc):
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, timeoutFunc)
	_timer.set_wait_time(2)
	_timer.set_one_shot(true) # Make sure it loops
	_timer.start()
	paused = true
