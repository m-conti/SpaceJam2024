class_name UILeaderboard
extends Leaderboard


var ScoreLine = preload("res://UI/leaderBoard/score_line.tscn")


static func show(scene_to_hide: Node):
	Game.back_scene = scene_to_hide
	scene_to_hide.visible = false
	var scene = preload("res://UI/leaderBoard/leaderboard.tscn").instantiate()
	scene_to_hide.get_parent().add_child(scene)


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
	Game.back_scene.visible = true
	queue_free()
