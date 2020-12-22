extends Node

var targetPosition
var targetNode
var navPath
var movingNode
var navNode
var rotationHandler
var updatePathRange = 20

var targetHandler

func setUp(_movingNode, _navNode, _rotationHandler):
	movingNode = _movingNode
	navNode = _navNode
	rotationHandler = _rotationHandler
	
func physics_process(delta):
	# Following player
	if targetNode != null:
		if targetPosition == null:
			navPath = navNode.get_simple_path(movingNode.global_position, targetNode.global_position)
			navPath.remove(0)
			targetPosition = navPath[0]
		elif targetNode.global_position.distance_to(targetPosition) > updatePathRange:
			navPath = navNode.get_simple_path(movingNode.global_position, targetNode.global_position)
			targetPosition = targetNode.global_position

	# Moving towards target
	elif targetPosition != null:
		if navPath == null:
			navPath = navNode.get_simple_path(movingNode.global_position, targetPosition)
			navPath.remove(0)

	if navPath != null and navPath.size() != 0:
		if moveTowardsTarget(delta):
			navPath.remove(0)
			if navPath.size() == 0:
				targetPosition = null
				navPath = null
				if targetHandler != null:
					targetHandler.reachedTargetPosition()

func moveTowardsTarget(delta):
	var moveDistance = movingNode.speed * delta
	var startPoint = movingNode.global_position
	var distToTarget = startPoint.distance_to(navPath[0])
	if moveDistance <= distToTarget:
		movingNode.global_position = startPoint.linear_interpolate(navPath[0], moveDistance / distToTarget)
		var newRot = rotationHandler.lerpAngle(movingNode.rotation, movingNode.global_position.direction_to(navPath[0]).angle(), 0.08)
		movingNode.rotation = newRot
	else:
		movingNode.global_position = navPath[0]
		return true
	return false
	
func chaseTarget(nodeToChase):
	targetPosition = null
	navPath = null
	targetNode = nodeToChase
	
func clearTarget():
	targetNode = null
	
func stopMoving():
	targetPosition = null
	targetNode = null
	navPath = null
	
func setTargetPosition(positionToMoveTo):
	navPath = null
	targetNode = null
	targetPosition = positionToMoveTo
