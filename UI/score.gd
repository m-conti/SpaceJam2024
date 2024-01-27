class_name Score
extends Label


func _on_character_score_changed(value):
	text = "Score : " + str(value)
