extends Node

var walkingRadius = 60
var runningRadius = 120

var runningTime = 0.5
var walkingTime = 1.0

var enemies = []
var _timer = null

func _init():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _on_Timer_timeout():
	emitSound()

func setWalkingRadius():
	get_node("../SoundRadiusArea2D/CollisionShape2D").shape.radius = walkingRadius
	_timer.set_wait_time(walkingTime)
	_timer.start()
	
func setRunningRadius():
	get_node("../SoundRadiusArea2D/CollisionShape2D").shape.radius = runningRadius
	_timer.set_wait_time(runningTime)
	_timer.start()

func _on_SoundRadiusArea2D_body_entered(body):
	print(body.name, "entered")
	if body.has_method("detectSound"):
		enemies.append(body)

func _on_SoundRadiusArea2D_body_exited(body):
	print(body.name, "exited")
	if body.has_method("detectSound"):
		enemies.erase(body)
	
func emitSound():
	for enemy in enemies:
		enemy.detectSound(get_parent())
