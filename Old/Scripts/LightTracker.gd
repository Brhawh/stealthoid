var lightLevel = 0

signal lightUpdated

func addLight(lightToAdd):
	lightLevel += lightToAdd
	lightUpdated()

func removeLight(lightToAdd):
	lightLevel -= lightToAdd
	lightUpdated()

func lightUpdated():
	emit_signal("lightUpdated", lightLevel)
