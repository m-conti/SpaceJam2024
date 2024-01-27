extends Control
class_name PowerTile

var Power

signal choosePower

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func init_tile(power):
	(%Name as Label).text = power.get_display_name()
	(%Description as Label).text = power.get_description()
	(%Count as Label).text = "%d / %d" % [ power.current_count, power.max_count]
	Power = power

func _on_select():
	print("onSelect")
	var power = Power.new()
	get_tree().root.add_child(power)
	power._activate()
	choosePower.emit()
