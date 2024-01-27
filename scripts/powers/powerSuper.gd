class_name PowerSuper
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var probability: float = 0.1

var super_zombies: Array = []


func _activate():
	PowerLife.max_count -= 1
	for zombie: Zombie in get_tree().get_nodes_in_group("zombies"):
		if randf() >= probability:
			continue
		
		zombie.walkSpeed *= 1.5
		zombie.runSpeed *= 1.5
		zombie.scale *= 1.5
		zombie.health *= 2
