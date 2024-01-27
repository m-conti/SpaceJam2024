class_name PowerSuper
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var probability: float = 0.1


static func get_description() -> String:
    return "Transforms 10% of your zombies (and future zombies) into super zombies. Super zombies are faster and bigger."

func _activate():
    PowerSuper.current_count += 1
    super._activate()


func _activate_on_zombie(zombie: Zombie):
    if randf() >= probability:
        return
    
    zombie.walkSpeed *= 1.5
    zombie.runSpeed *= 1.5
    zombie.scale *= 1.5
