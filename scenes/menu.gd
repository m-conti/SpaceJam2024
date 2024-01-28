extends Authentication


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()



func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	pass # Replace with function body.


func _on_leader_board_pressed():
	get_tree().change_scene_to_file("res://UI/leaderBoard/leaderboard.tscn")
	pass # Replace with function body.
