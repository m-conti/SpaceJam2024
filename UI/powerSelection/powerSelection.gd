extends CanvasLayer
class_name PowerSelection

var powerTile: PackedScene = preload("res://UI/powerSelection/power.tscn")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var powers = Game.getPower(3)
	for power in powers:
		var tile = powerTile.instantiate()
		(%PowerBox as Container).add_child(tile)
		(tile as PowerTile).init_tile(power)
		(tile as PowerTile).choosePower.connect(removeLvlUp)

func removeLvlUp():
	print("removeLvlUp")
	queue_free()
	get_tree().paused = false

