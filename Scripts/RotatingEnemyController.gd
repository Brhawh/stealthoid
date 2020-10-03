extends KinematicBody2D

export (Array, Vector2) onready var patrolPoints
export (float) onready var speed
export (Array, float) onready var guardingDegrees
export(Vector2) onready var guardPostLocation
export (NodePath) onready var targetPath

var navigator
var fsm: StateMachine

func _ready():
	if navigator == null:
		set_physics_process(false)

func _physics_process(delta):
	update()
	fsm._physics_process(delta)
	
func onNavigatorReady(_navigator):
	navigator = _navigator
	fsm = createStateMachine()
	get_node("Detector").setupTargetHandling(fsm, get_node(targetPath))
	set_physics_process(true)
	
func detectSound(soundSource):
	if fsm.state.name != "Chasing":
		print(soundSource)
		get_node("StateMachine/Chasing").target = soundSource
		fsm.state.exit("Chasing")
		
func createStateMachine():
	var mover = get_node("Mover")
	var detector = get_node("Detector")
	
	# Create base state machine
	var stateMachine = preload("res://Scripts/EnemyStateMachine.gd").new()
	stateMachine.name = "StateMachine"
	
	#Create patrolling state
	var patrollingNode = preload("res://Scripts/Patrolling.gd").new(patrolPoints, mover, navigator, self, speed)
	patrollingNode.name = "Patrolling"
	
	#Create guarding state
	var guardingNode = preload("res://Scripts/Guarding.gd").new(navigator, self, mover, speed, guardPostLocation, guardingDegrees)
	guardingNode.name = "Guarding"
	
	#Create chasing state
	var chasingNode = preload("res://Scripts/Chasing.gd").new(self, mover, speed, navigator)
	chasingNode.name = "Chasing"
	
	#Create attacking state
	var attackingNode = preload("res://Scripts/Attacking.gd").new()
	attackingNode.name = "Attacking"
	
	#Create investigating state
	var investigatingNode = preload("res://Scripts/Investigating.gd").new(navigator, self, speed, mover)
	investigatingNode.name = "Investigating"
	
	stateMachine.add_child(patrollingNode)
	stateMachine.add_child(guardingNode)
	stateMachine.add_child(chasingNode)
	stateMachine.add_child(attackingNode)
	stateMachine.add_child(investigatingNode)
	add_child(stateMachine)
	
	connect("targetChanged", patrollingNode, "_on_Enemy_targetChanged")
	connect("targetChanged", guardingNode, "_on_Enemy_targetChanged")
	connect("targetChanged", chasingNode, "_on_Enemy_targetChanged")
	connect("targetChanged", investigatingNode, "_on_Enemy_targetChanged")
	
	return stateMachine
