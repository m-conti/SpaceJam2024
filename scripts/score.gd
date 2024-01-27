class_name Score
extends Label


func _on_score_changed(new_score):
    text = "Score : " + str(new_score)