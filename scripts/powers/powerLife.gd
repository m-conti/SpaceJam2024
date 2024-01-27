class_name PowerLife
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var life: int = 1


func _activate():
    PowerLife.current_count += 1
    super._activate()


static func get_description() -> String:
    return "Increases the life of your zombies by 1."


func _activate_on_zombie(zombie: Zombie):
    zombie.max_life += life

