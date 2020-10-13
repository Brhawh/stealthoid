extends Node

var walkingRadius = 30
var runningRadius = 60

var runningTime = 0.5
var walkingTime = 1.0

var currentTime

var enemies = []
var _timer = null

func _init():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.0)
	_timer.set_one_shot(false) # Make sure it loops

func _on_Timer_timeout():
	emitSound()

func setWalkingState():
	get_node("../SoundRadiusArea2D/CollisionShape2D").shape.radius = walkingRadius
	currentTime = walkingTime
	
func setRunningState():
	get_node("../SoundRadiusArea2D/CollisionShape2D").shape.radius = runningRadius
	currentTime = runningTime
	
func startEmittingSound():
	emitSound()
	_timer.set_wait_time(currentTime)
	_timer.start()
	
func stopEmittingSound():
	_timer.stop()

func _on_SoundRadiusArea2D_body_entered(body):
	if body.has_method("detectSound"):
		enemies.append(body)

func _on_SoundRadiusArea2D_body_exited(body):
	if body.has_method("detectSound"):
		enemies.erase(body)
	
func emitSound():
	for enemy in enemies:
		enemy.detectSound(get_parent())
	
	var particleNode = preload("res://scenes/Particles/StepIndicatorParticles.tscn").instance()
	var particleMaterial = preload("res://scenes/Particles/StepIndicatorParticles.tres")
	particleMaterial.initial_velocity = get_node("../SoundRadiusArea2D/CollisionShape2D").shape.radius 
	particleNode.process_material = particleMaterial
	get_parent().get_parent().add_child(particleNode)
	particleNode.global_position = get_parent().global_position
	particleNode.emitting = true
