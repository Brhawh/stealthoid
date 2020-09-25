extends Node

var fsm: StateMachine

onready var parent = get_parent().get_parent()
var navigator

func _init(navigator):
	return

#func _ready():
#	var tileMap = navigator.get_node("TileMap")
#	var cellPos = tileMap.world_to_map(parent.global_position)
#	var cell = tileMap.get_cellv(cellPos)
#	print(cell)

func enter():
	#get tile enemy is on
	#get tiles on 4 sides of that tile
	#check if each tile is navigable
	#if tile is navigable, add its center to list of points to investigate
	return

func exit(next_state):
	fsm.change_to(next_state)

func process(delta):
	return delta

func physics_process(delta):
	return delta

func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]
