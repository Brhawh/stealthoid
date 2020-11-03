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

var rotationHandler = load("res://Scripts/RotationHandler.gd").new()

func _ready():
	get_node("Detector").setupTargetHandling(fsm, get_node(targetPath))
	for state in fsm.get_children():
		state.setUp(self)

func _physics_process(delta):
	fsm.physics_process(delta)
	
func detectSound(soundSource):
	if fsm.state.name != "Chasing":
		print(soundSource)
		get_node("StateMachine/Chasing").target = soundSource
		fsm.state.exit("Chasing")
