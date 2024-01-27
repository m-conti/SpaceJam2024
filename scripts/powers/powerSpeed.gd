class_name PowerSpeed
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var speed_factor: float = 1.5


func _activate():
	PowerLife.max_count -= 1
	for zombie: Zombie in get_tree().get_nodes_in_group("zombie"):
		zombie.walkSpeed *= speed_factor
		zombie.runSpeed *= speed_factor
