extends Leaderboard


func _ready():
	var new_score: int = Game.score
	Game.score = 0

	_upload_score(new_score)
	%Score.text = "Score : " + str(new_score)


func retry():
	get_tree().change_scene_to_file("res://Scenes/map.tscn")


func leaderboard():
	UILeaderboard.show(self)


func quit():
	get_tree().quit()