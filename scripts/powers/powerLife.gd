class_name PowerLife
extends Power

static var max_count: int = 4
static var current_count: int = 0

@export var life: float = 0.2


func _activate():
	PowerLife.current_count += 1
	super._activate()


static func get_description() -> String:
	return "Increases the life of your zombies by 20%."

static func get_display_name() -> String:
	return "Life"

func _activate_on_zombie(zombie: Zombie):
	zombie.max_life += zombie.max_life * life

