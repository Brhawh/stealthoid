extends KinematicBody2D

class_name EnemyController

export (Array, Vector2) onready var patrolPoints
export (float) onready var speed
export (Array, float) onready var guardingDegrees
export (Vector2) onready var guardPostLocation
export (NodePath) onready var targetPath

onready var navigator = $"../Navigation2D"
onready var fsm: StateMachine = $"StateMachine"
onready var mover = $"Mover"

export(float) var minLightLevel
export(float) var maxLightLevel
export(float) var baseSpeed
export(float) var visionLightLevel
var lightLevel = 0

var rotationHandler = load("res://Scripts/RotationHandler.gd").new()

func _ready():
	get_node("Detector").setupTargetHandling(fsm, get_node(targetPath), visionLightLevel)
	mover.setUp(self, navigator, rotationHandler)
	var states = fsm.get_children()
	for state in states:
		state.setUp(self)
	fsm.state = states[0]
	fsm._enter_state()

func _physics_process(delta):
	fsm.physics_process(delta)
	mover.physics_process(delta)
	
func detectSound(soundSource):
	if fsm.state.name != "Chasing":
		get_node("StateMachine/Chasing").target = soundSource
		fsm.state.exit("Chasing")
		
func addLight(lightLevelToAdd):
	lightLevel += lightLevelToAdd
	updateSpeed()
	
func removeLight(lightLevelToRemove):
	lightLevel -= lightLevelToRemove
	updateSpeed()
		
func updateSpeed():
	if lightLevel > maxLightLevel:
		speed = baseSpeed + maxLightLevel
	elif lightLevel < minLightLevel:
		speed = baseSpeed
	else:
		speed = baseSpeed + lightLevel
