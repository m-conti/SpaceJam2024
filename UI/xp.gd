extends Label
class_name XpLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.xp_changed.connect(_on_xp_changed)
	_on_xp_changed()

func _on_xp_changed():
	text = "xp : %d / %d" % [Game.current_xp, Game.xp_needed]

