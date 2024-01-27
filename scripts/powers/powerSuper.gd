class_name PowerSuper
extends Power


@export var probability: float = 0.1

var super_zombies: Array = []


func _activate():
    for zombie: Zombie in get_tree().get_nodes_in_group("zombies"):
        if randf() >= probability:
            continue
        
        zombie.walkSpeed *= 1.5
        zombie.runSpeed *= 1.5
        zombie.scale *= 1.5
        zombie.health *= 2
