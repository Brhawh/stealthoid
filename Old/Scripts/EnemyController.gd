extends KinematicBody2D

class_name EnemyController

export (Array, Vector2) onready var patrolPoints
onready var speed
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
export(bool) var lightActivated

var lightTracker = load("res://Scripts/LightTracker.gd").new()
var rotationHandler = load("res://Scripts/RotationHandler.gd").new()

func _ready():
	# Set up enemy component nodes
	get_node("Detector").setupTargetHandling(fsm, get_node(targetPath), visionLightLevel)
	print(navigator)
	mover.setUp(self, navigator)
	
	# Set up finite state machine
	var states = fsm.get_children()
	for state in states:
		state.setUp(self)
	fsm.state = states[0]
	fsm._enter_state()
	
	# Set up lightTracker
	lightTracker.connect("lightUpdated", self, "updateSpeed")
	
	if !lightActivated:
		remove_child(get_node("EnemyTorchLight"))
		lightTracker.lightUpdated()
	else:
		lightTracker.addLight(get_node("EnemyTorchLight").lightLevelEmitted)

func _physics_process(delta):
	fsm.physics_process(delta)
	mover.physics_process(delta)

	if self.name == "Enemy":
		print(mover.isMoving(), mover.getMoveDirection())
	
	setAnimation(mover.isMoving(), mover.getMoveDirection())

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
		
func setAnimation(isMoving, direction):
	var animNode = get_node("EnemySprite")
	if isMoving:
		if direction < 45 and direction > -45:
			animNode.play("WalkRight")
		elif direction > 45 and direction < 135:
			animNode.play("WalkFront")
		elif (direction > 135 and direction < 325) or (direction < -135 and direction > - 325):
			animNode.play("WalkLeft")
		elif direction < -45 and direction > -135:
			animNode.play("WalkBack")
