extends CanvasLayer

var powerTile: PackedScene = preload("res://UI/powerSelection/power.tscn")

func _ready():
	var powers = Game.getPower(3)
	for power in powers:
		var tile = powerTile.instantiate()
		(%PowerBox as Container).add_child(tile)
		(tile as PowerTile).init_tile(power)
	pass # Replace with function body.
