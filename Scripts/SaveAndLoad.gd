extends Node

var path = "res://Saves/data.json"

var defaultData = {
	"player" : {
		"gold" : 0,
		"deaths": 0 
	},
	"levelsCompleted" : [1, 2]
}

var data = {}

func _ready():
	loadGame()

func loadGame():
	var file = File.new()
	file.open(path, file.READ)
	if not file.file_exists(path):
		resetData()
		saveGame()
		print("creating file")
		return
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()
	print("file found")

func saveGame():
	print("saving")
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	

func resetData():
	print("saving default data")
	data = defaultData.duplicate(true)
