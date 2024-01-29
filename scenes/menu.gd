extends Authentication

var PlayerNameScene = preload("res://UI/playerName/player_name.tscn")
var playerNameScene  

var player_name: String = ""

signal name_choosed(value: String)
signal name_already_used

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	await super._ready()
	name_choosed.connect(_on_name_choosed)
	self.visible = true
	askChooseNameIfNeeded()

func askChooseNameIfNeeded():
	var response = await _get_player_name()
	if response.name != "":
		player_name = response.name
		return
	get_tree().paused = true
	playerNameScene = PlayerNameScene.instantiate()
	add_child(playerNameScene)

func _on_name_choosed(value: String):
	if value == "":
		return
	if player_name != value:
		var res: Dictionary = await _change_player_name(value)
		if not res.has(name):
			if (res.message as String).ends_with("not unique"):
				name_already_used.emit()
			return
		player_name = res.name
	(playerNameScene as Node).queue_free()
	playerNameScene = null
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_leader_board_pressed():
	UILeaderboard.show(self)


func _on_change_name_pressed():
	playerNameScene = PlayerNameScene.instantiate()
	playerNameScene.get_node("%Name").text = player_name
	add_child(playerNameScene)
