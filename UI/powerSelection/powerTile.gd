extends Control
class_name PowerTile

var Power

func init_tile(power):
	(%Name as Label).text = power.display_name
	(%Description as Label).text = power.description
	(%Count as Label).text = "%d / %d" % [ power.current_count, power.max_count]
	Power = power
