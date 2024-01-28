extends Leaderboard

var ScoreLine = preload("res://UI/leaderBoard/score_line.tscn")

func addScoreLine(line):
	var scoreLine = ScoreLine.instantiate()
	scoreLine.setName(line.player.name)
	scoreLine.setScore(line.score)
	scoreLine.setRank(line.rank)
	%Container.add_child(scoreLine)

func _ready():
	var board = await _get_leaderboards()
	for item in board.items:
		addScoreLine(item)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	pass # Replace with function body.
