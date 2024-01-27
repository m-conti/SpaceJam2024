class_name PowerSuper
extends Power


@export var probability: float = 0.1


func _activate_on_zombie(zombie: Zombie):
    if randf() >= probability:
        return
    
    zombie.walkSpeed *= 1.5
    zombie.runSpeed *= 1.5
    zombie.scale *= 1.5
