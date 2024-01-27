class_name PowerSpeed
extends Power


@export var speed_factor: float = 1.5


static func get_description() -> String:
    return "Makes your zombies faster."


func _activate_on_zombie(zombie: Zombie):
    zombie.walkSpeed *= speed_factor
    zombie.runSpeed *= speed_factor