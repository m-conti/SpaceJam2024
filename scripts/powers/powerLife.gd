class_name PowerLife
extends Power

static var max_count: float = 4
static var current_count: float = 0
@export var life: int = 1


func _activate():
	PowerLife.max_count -= 1
	for zombie in get_tree().get_nodes_in_group("zombie"):
		zombie.max_life += life

