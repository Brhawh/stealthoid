extends KinematicBody2D

export (float) var speed = 1
export (Vector2) var destination
export (Vector2) var initial
var initialJourney = true

func _ready():
	pass


func _process(delta):
	if initialJourney:
		position.x += speed
		if position >= destination:
			initialJourney = false
			$AnimatedSprite.animation = "left"
	elif !initialJourney:
		position.x -= speed
		if position <= initial:
			initialJourney = true
			$AnimatedSprite.animation = "right"
