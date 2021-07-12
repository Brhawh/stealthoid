extends Node

var itemsInRange = []
var equippedItem = null

func _input(event):
	if Input.is_action_just_pressed("interact") and !itemsInRange.empty():
		equippedItem = itemsInRange[0]
		itemsInRange[0].pickUpItem(get_parent())

func add_item_in_range(itemNode):
	itemsInRange.append(itemNode)
	print(itemsInRange)
	
func remove_item_out_range(itemNode):
	itemsInRange.remove(itemsInRange.find(itemNode))
	print(itemsInRange)
