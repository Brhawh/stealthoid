extends Node

func moveAlongPath(delta, speed, navPath, parentNode):
	var moveDistance = speed * delta
	var startPoint = parentNode.position
	# Move through positions until movement actually occurs or path end is reached
	for i in navPath.size():
		var distToNext = startPoint.distance_to(navPath[0])
		if moveDistance <= distToNext and moveDistance >- 0.0:
			parentNode.position = startPoint.linear_interpolate(navPath[0], moveDistance / distToNext)
			break
		elif distToNext <= 5.0:
			parentNode.position = navPath[0]
		moveDistance -= distToNext
		startPoint = navPath[0]
		navPath.remove(0)
	return navPath