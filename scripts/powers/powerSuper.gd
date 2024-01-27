class_name PowerSuper
extends Power


@export var probability: float = 0.1


static func get_description() -> String:
    return "Transforms 10% of your zombies (and future zombies) into super zombies. Super zombies are faster and bigger."


func _activate_on_zombie(zombie: Zombie):
    if randf() >= probability:
        return
    
    zombie.walkSpeed *= 1.5
    zombie.runSpeed *= 1.5
    zombie.scale *= 1.5
