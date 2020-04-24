extends KinematicBody2D

export (Array, Vector2) var patrolPoints setget patrolPointsSet
export (float) var speed setget speedSet
export (Array, float) var guardingDegrees setget guardingDegreesSet
export (NodePath) var chasingNavigatorPath
export(Vector2) var guardPostLocation setget guardLocationSet

onready var detector = $Detector
onready var navigator: Navigation2D = get_node("../../Navigation2D")
onready var fsm: StateMachine = get_node("StateMachine")

func _ready():
	chasingNavigatorSet(chasingNavigatorPath)
	chasingDetectorSet(detector)

func _physics_process(delta):
	update()
	fsm._physics_process(delta)

func _on_EnemyViewRadius_body_entered(body):
	if body.name == "Character" && (fsm.state.name == "Patrolling" || fsm.state.name == "Guarding"):
		fsm.state.target = body

func _on_EnemyViewRadius_body_exited(body):
	if body.name == "Character" && (fsm.state.name == "Patrolling" || fsm.state.name == "Guarding"):
		fsm.state.target = null
	
func patrolPointsSet(patrolPoints):
	get_node("StateMachine/Patrolling").patrolPoints = patrolPoints
	
func speedSet(speed):
	get_node("StateMachine/Patrolling").speed = speed
	get_node("StateMachine/Chasing").speed = speed
	get_node("StateMachine/Guarding").speed = speed
	
func guardingDegreesSet(degrees):
	get_node("StateMachine/Guarding").rotationDegrees = degrees
	
func guardLocationSet(location):
	get_node("StateMachine/Guarding").guardLocation = location

func chasingNavigatorSet(navigatorPath):
	get_node("StateMachine/Chasing").navigator = get_node(navigatorPath)
	get_node("StateMachine/Guarding").navigator = get_node(navigatorPath)
	get_node("StateMachine/Patrolling").navigator = get_node(navigatorPath)
	
func chasingDetectorSet(detector):
	get_node("StateMachine/Chasing").detector = detector
	get_node("StateMachine/Patrolling").detector = detector
	get_node("StateMachine/Guarding").detector = detector
