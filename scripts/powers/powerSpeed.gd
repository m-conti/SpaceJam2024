class_name PowerSpeed
extends Power

static var max_count: int = 4
static var current_count: int = 0

@export var speed_factor: float = 1.2


func _activate():
	PowerSpeed.current_count += 1
	super._activate()


static func get_description() -> String:
	return "Makes your zombies faster."

static func get_display_name() -> String:
	return "Speed"

func _activate_on_zombie(zombie: Zombie):
	zombie.walkSpeed *= speed_factor
	zombie.runSpeed *= speed_factor
