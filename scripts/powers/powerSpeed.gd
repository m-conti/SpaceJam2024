class_name PowerSpeed
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var speed_factor: float = 1.5


func _activate():
    PowerSpeed.current_count += 1
    super._activate()

static func get_description() -> String:
    return "Makes your zombies faster."


func _activate_on_zombie(zombie: Zombie):
    zombie.walkSpeed *= speed_factor
    zombie.runSpeed *= speed_factor
