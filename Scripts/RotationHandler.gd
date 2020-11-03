class_name RotationHandler

var maxAngle = PI * 2
	
func lerpAngle(from, to, weight):
	var lerpAngle = from + short_angle_dist(from, to) * weight
	if lerpAngle > maxAngle:
		lerpAngle -= maxAngle
	elif lerpAngle < 0:
		lerpAngle += maxAngle
	return lerpAngle

func short_angle_dist(from, to):
	var difference = fmod(to - from, maxAngle)
	return fmod(2 * difference, maxAngle) - difference
