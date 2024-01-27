extends Label
class_name LvlLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.lvl_changed.connect(_on_lvl_changed)
	_on_lvl_changed()


func _on_lvl_changed():
	text = "lvl : %d" % [Game.lvl]
