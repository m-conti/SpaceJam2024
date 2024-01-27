class_name PowerSpeed
extends Power


@export var speed_factor: float = 1.5


func _activate():
    for zombie: Zombie in get_tree().get_nodes_in_group("zombie"):
        zombie.walkSpeed *= speed_factor
        zombie.runSpeed *= speed_factor
