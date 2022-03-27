extends KinematicBody2D

class_name EnemyController

export (Array, Vector2) onready var patrolPoints
onready var speed = baseSpeed
export (Array, float) onready var guardingDegrees
export (Vector2) onready var guardPostLocation
export (NodePath) onready var targetPath

onready var navigator = $"../Navigation2D"
onready var fsm: StateMachine = $"StateMachine"
onready var mover = $"Mover"
onready var viewArea = $"EnemyViewRadius"

export(float) var minLightLevel
export(float) var maxLightLevel
export(float) var baseSpeed
export(float) var visionLightLevel
export(bool) var lightActivated

var rotationHandler = load("res://Entities/Humanoid/RotationHandler.gd").new()

func _ready():
	# Set up enemy component nodes
	get_node("Detector").setupTargetHandling(fsm, get_node(targetPath), visionLightLevel)
	mover.setUp(self, navigator)
	
	# Set up finite state machine
	var states = fsm.get_children()
	for state in states:
		state.setUp(self)
	fsm.state = states[0]
	fsm._enter_state()

func _physics_process(delta):
	fsm.physics_process(delta)
	mover.physics_process(delta)
	
	handleDirection()

func detectSound(soundSource):
	var currentState = fsm.state.name
	if currentState != "Chasing" and currentState != "Sleeping":
		fsm.state.exit("Chasing")
		fsm.get_node("Chasing").chaseSound(soundSource)
	
func updateSpeed(lightLevel):
	if lightLevel > maxLightLevel:
		speed = baseSpeed + maxLightLevel
	elif lightLevel < minLightLevel:
		speed = baseSpeed
	else:
		speed = baseSpeed + lightLevel
		
	if speed <= 0:
		fsm.enterSleep()
	else:
		fsm.wakeUp()
		
func handleDirection():
	var animNode = get_node("EnemySprite")
	var isMoving = mover.isMoving()
	var direction = mover.getMoveDirection()
	if isMoving:
		if direction < 45 and direction > -45:
			animNode.play("WalkRight")
			viewArea.rotation_degrees = 0
		elif direction > 45 and direction < 135:
			animNode.play("WalkFront")
			viewArea.rotation_degrees = 90
		elif (direction > 135 and direction < 325) or (direction < -135 and direction > - 325):
			animNode.play("WalkLeft")
			viewArea.rotation_degrees = 180
		elif direction < -45 and direction > -135:
			animNode.play("WalkBack")
			viewArea.rotation_degrees = 270