extends Node2D

var targetHandler
var target
var targetInArea = false

func setupTargetHandling(_targetHandler, _target):
	targetHandler = _targetHandler
	target = _target
	
func _physics_process(delta):
	if target != null && targetInArea:
		var hitPos = detect_target()
		if !hitPos.empty() && target.lightLevel > 0:
			targetHandler.handleTargetDetected(target)
		else:
			targetHandler.handleTargetLost()

func detect_target():
	var hitPos = []
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(global_position, target.global_position, [get_parent()])
	if result && result.collider.name == target.name:
		hitPos.append(result.position)
	return hitPos

func _on_EnemyViewRadius_body_entered(body):
	if body.name == target.name:
		targetInArea = true

func _on_EnemyViewRadius_body_exited(body):
	if body.name == target.name:
		targetInArea = false
